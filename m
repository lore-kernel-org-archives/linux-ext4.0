From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Wed, 6 Mar 2013 08:13:55 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303060753500.24359@localhost>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, Chris Ball <cjb@laptop.org>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab3CFHOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Mar 2013 02:14:05 -0500
In-Reply-To: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 5 Mar 2013, Stephen Warren wrote:

> Date: Tue,  5 Mar 2013 13:25:18 -0700
> From: Stephen Warren <swarren@wwwdotorg.org>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
>     Stephen Warren <swarren@nvidia.com>
> Subject: [PATCH] mke2fs: restore verbose message for BLKDISCARD
> 
> From: Stephen Warren <swarren@nvidia.com>
> 
> mke2fs on a large slow eMMC device may appear to hang while executing
> ioctl(BLKDISCARD). CTRL-C and CTRL-\ don't appear to respond, or respond
> extremely slowly. -v doesn't give any hints what's happening. Only strace
> is a clue. Make -v print some clues to make it easier to track down the
> apparent hang.
> 
> This change re-uses the original messages that were implemented as part
> of 5827d24 "mke2fs support for BLKDISCARD" in order to easily re-use the
> translations of that message. Note that this patch prints the first
> message before executing the IOCTL, so the user is told what's going on
> before the long wait.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Note that you've added the message only around the first 4k discard
which is only used to test whether the device actually support the
discard... which is not very useful and it can not even know whether
the whole device discard will succeed/fail so it is misleading.

Moreover there actually is a message saying that we're "Discarding
device blocks" and it even shows the progress. The step in which
we're doing the discard (and update the progress) is given by
DISCARD_STEP_MB = 2048MB. And all that in non verbose mode as well.

So what's happening in your case is that your message will not be
written to the output stream (no newline) for some reason even though
that we call fflush() after fputs(). I am not sure how to fix it
though since I always find this stream buffering and fflush quite
confusing and it never worked properly for me...

-Lukas

> ---
> Note: I've left mke2fs running for a while now (tens of minutes on a 16GiB
> eMMC), and this IOCTL still hasn't completed. I'm not sure how long it's
> meant to take. Perhaps the long execution time is actually a kernel bug in
> the MMC core or our SDHCI driver.

As mentioned we're doing 2GB discard steps so the problem really
should not be on mkfs side. It is very much possible that the
discard implementation on the eMMC is terribly slow (which does not
surprise me). What is says about itself ?

grep . /sys/block/sda/queue/discard_*

> ---
>  misc/mke2fs.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bbf477a..defb932 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2272,7 +2272,20 @@ static int mke2fs_discard_device(ext2_filsys fs)
>  	 * we do not print numeric progress resulting in failure
>  	 * afterwards.
>  	 */
> +	if (verbose) {
> +		printf(_("Calling BLKDISCARD from %llu to %llu "),
> +			(unsigned long long)0,
> +			(unsigned long long)fs->blocksize);
> +		fflush(stdout);
> +	}
>  	retval = io_channel_discard(fs->io, 0, fs->blocksize);
> +	if (verbose) {
> +		if (retval)
> +			printf(_("failed.\n"));
> +		else
> +			printf(_("succeeded.\n"));
> +	}
> +
>  	if (retval)
>  		return retval;
>  	cur = fs->blocksize;
> 
