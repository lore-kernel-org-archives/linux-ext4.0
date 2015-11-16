From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] common: Add function for selecting from different
 output files
Date: Tue, 17 Nov 2015 08:29:24 +1100
Message-ID: <20151116212924.GL14311@dastard>
References: <1446654698-23577-1-git-send-email-jack@suse.com>
 <1446654698-23577-4-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446654698-23577-4-git-send-email-jack@suse.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 04, 2015 at 05:31:37PM +0100, Jan Kara wrote:
> Add function for selection of different output files. The idea is that
> in config file ($seq.cfg) there are several lines like:
> 
> feat1,feat2: suffix
> 
> The function is passed a feature string (or uses MOUNT_OPTIONS if no
> argument is passed) and selects output file with a suffix for which all
> features are present in the feature string. If there is no matching
> line, output with 'default' suffix is selected.
> 
> Signed-off-by: Jan Kara <jack@suse.com>

Looks like a good idea, but probably needs to be integrated into
_link_out_file(), which already does platform based output file
linking...

> ---
>  common/rc | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index adf1edf64d8d..543780c92c59 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3142,6 +3142,47 @@ get_block_size()
>  	echo `stat -f -c %S $1`
>  }
>  
> +_select_output()
> +{
> +	if [ $# -eq 0 ]; then
> +		FEATURES=${MOUNT_OPTIONS##"-o "}
> +	else
> +		FEATURES=$1
> +	fi
> +
> +	export FEATURES
> +	seqfull=$SRC_DIR/$seqnum
> +	perl -e '
> +		my %feathash;
> +		my $feature, $result, $suffix, $opts;
> +
> +		foreach $feature (split(/,/, $ENV{"FEATURES"})) {
> +			$feathash{$feature} = 1;
> +		}
> +		$result = "default";
> +		while (<>) {
> +			my $found = 1;
> +
> +			chomp;
> +			($opts, $suffix) = split(/ *: */);
> +			foreach my $opt (split(/,/, $opts)) {
> +				if (!exists($feathash{$opt})) {
> +					$found = 0;
> +					last;
> +				}
> +			}
> +			if ($found == 1) {
> +				$result = $suffix;
> +				last;
> +			}
> +		}
> +		print $result
> +		' <$seqfull.cfg | {
> +			read SUFFIX
> +			ln -fs $seq.out.$SUFFIX $seqfull.out
> +		}
> +}

I'd much prefer the perl code simply returns the appropriately
matched suffix and then the shell code does the linking of the
output file. That way other things that the test harness is aware of
can also be taken into account.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
