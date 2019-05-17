package MMTests::ExtractVmscale;
use MMTests::SummariseSingleops;
use MMTests::Stat;
our @ISA = qw(MMTests::SummariseSingleops);
use strict;

sub initialise() {
	my ($self, $reportDir, $testName) = @_;

	my $fieldLength = $self->{_FieldLength} = 25;
	$self->{_ModuleName} = "ExtractVmscale";
	$self->{_DataType} = DataTypes::DATA_TIME_SECONDS;
	$self->{_TestName} = $testName;
	$self->{_Opname} = "Value";

	$self->SUPER::initialise($reportDir, $testName);
}

sub extractReport() {
	my ($self, $reportDir, $reportName, $profile) = @_;
	my @cases;

	open(INPUT, "$reportDir/$profile/cases") || die "Failed to open cases file";
	while (!eof(INPUT)) {
		my $line = <INPUT>;
		chomp($line);
		push @cases, $line;
	}
	close(INPUT);
	$self->{_Cases} = \@cases;
	my @ratioops;

	foreach my $case (@cases) {
		open(INPUT, "$reportDir/$profile/$case.time") ||
			die("Failed to open $reportDir/$profile/$case.time");
		while (!eof(INPUT)) {
			my $line = <INPUT>;
			next if $line !~ /elapsed/;
			$self->addData("$case-elapsed", 0, $self->_time_to_elapsed($line));
			push @ratioops, "$case-elapsed";
		}
		close(INPUT);

		open(INPUT, "$reportDir/$profile/$case.log") ||
			die("Failed to open $reportDir/$profile/$case.log");

		if ($case eq "lru-file-readonce" || $case eq "lru-file-readtwice") {
			my @values;
			while (!eof(INPUT)) {
				my $line = <INPUT>;
				next if $line !~ /elapsed/;
				push @values, $self->_time_to_elapsed($line);
			}
			$self->addData("$case-time_range", 0, calc_range(\@values));
			$self->addData("$case-time_stddv", 0, calc_stddev(\@values));
		}

		close(INPUT);
	}
	$self->{_RatioOperations} = \@ratioops;
}

1;
