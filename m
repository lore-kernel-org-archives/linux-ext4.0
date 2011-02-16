From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH V2] mke2fs: Inform user of ongoing discard
Date: Wed, 16 Feb 2011 11:38:02 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102161137100.4744@dhcp-27-109.brq.redhat.com>
References: <1295898720-2221-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab1BPKiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 05:38:07 -0500
In-Reply-To: <1295898720-2221-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Jan 2011, Lukas Czerner wrote:

> (V2: remove MB macro)
> 
> For some time now we are doing initial discard of the device prior to
> filesystem creation. However, there is no feedback for the user and
> hence on some devices with slow TRIM implementation it may appear that
> mke2fs is stuck.
> 
> This commit introduce new function mke2fs_discard_device(), which is a
> wrapper for io_channel_discard(). The discard is done per-partes and
> discard progress is being reported back to the user. The discard step
> has been set to 2GB size, which works reasonably well on both slow and
> fast devices.
> 
> I gave up on doing fancy things like align discard according to
> discard_alignment, checking for discard granularity and computing
> estimate time. First of all, because it would require either new ioctl
> to retrieve those information or use of libudev library, none of it
> seems to be worth it. Regarding discard_granularity, I doubt there is
> any sane device with discard granularity that big it would affect this.

Hi Ted,

if there are no objections, could you pick it up ?

Thanks!
-Lukas
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  misc/mke2fs.c |   54 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 41 insertions(+), 13 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bc1211d..8f358c6 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -72,6 +72,8 @@ extern int optind;
>  #define ZAP_BOOTBLOCK
>  #endif
>  
> +#define DISCARD_STEP_MB		(2048)
> +
>  extern int isatty(int);
>  extern FILE *fpopen(const char *cmd, const char *mode);
>  
> @@ -1922,6 +1924,44 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  	return retval;
>  }
>  
> +static int mke2fs_discard_device(ext2_filsys fs)
> +{
> +	struct ext2fs_numeric_progress_struct progress;
> +	blk64_t blocks = ext2fs_blocks_count(fs->super);
> +	blk64_t count = DISCARD_STEP_MB;
> +	blk64_t cur = 0;
> +	int retval = 0;
> +
> +	count *= (1024 * 1024);
> +	count /= fs->blocksize;
> +
> +	ext2fs_numeric_progress_init(fs, &progress,
> +				     _("Discarding device blocks: "),
> +				     blocks);
> +	while (cur < blocks) {
> +		ext2fs_numeric_progress_update(fs, &progress, cur);
> +
> +		if (cur + count > blocks)
> +			count = blocks - cur;
> +
> +		retval = io_channel_discard(fs->io, cur, count, fs->blocksize);
> +		if (retval)
> +			break;
> +		cur += count;
> +	}
> +
> +	if (retval) {
> +		ext2fs_numeric_progress_close(fs, &progress,
> +				      _("failed - "));
> +		if (!quiet)
> +			printf("%s\n",error_message(retval));
> +	} else
> +		ext2fs_numeric_progress_close(fs, &progress,
> +				      _("done                            \n"));
> +
> +	return retval;
> +}
> +
>  int main (int argc, char *argv[])
>  {
>  	errcode_t	retval = 0;
> @@ -1982,19 +2022,7 @@ int main (int argc, char *argv[])
>  
>  	/* Can't undo discard ... */
>  	if (discard && (io_ptr != undo_io_manager)) {
> -		blk64_t blocks = ext2fs_blocks_count(fs->super);
> -		if (verbose)
> -			printf(_("Calling BLKDISCARD from 0 to %llu... "),
> -			       (unsigned long long) blocks);
> -		retval = io_channel_discard(fs->io, 0, blocks, fs->blocksize);
> -		if (verbose) {
> -			if (retval)
> -				printf(_("failed (%s)\n"),
> -				       error_message(retval));
> -			else
> -				printf(_("succeeded\n"));
> -		}
> -
> +		retval = mke2fs_discard_device(fs);
>  		if (!retval && io_channel_discard_zeroes_data(fs->io)) {
>  			if (verbose)
>  				printf(_("Discard succeeded and will return 0s "
> 

-- 
