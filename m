From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] mke2fs: Inform user of ongoing discard
Date: Mon, 13 Dec 2010 23:40:12 +0800
Message-ID: <4D063E5C.2050301@tao.ma>
References: <1292233546-12017-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36523 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752923Ab0LMPk1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Dec 2010 10:40:27 -0500
In-Reply-To: <1292233546-12017-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Lukas,
On 12/13/2010 05:45 PM, Lukas Czerner wrote:
<snip>
> @@ -1922,6 +1925,44 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>   	return retval;
>   }
>
> +static int mke2fs_discard_device(ext2_filsys fs)
> +{
> +	struct ext2fs_numeric_progress_struct progress;
> +	blk64_t blocks = ext2fs_blocks_count(fs->super);
> +	blk64_t count = DISCARD_STEP_MB;
> +	blk64_t cur = 0;
> +	int retval = 0;
> +
> +	count *= MB;
> +	count /= fs->blocksize;
> +
> +	ext2fs_numeric_progress_init(fs,&progress,
> +				     _("Discarding device blocks: "),
> +				     blocks);
> +	while (cur<  blocks) {
> +		ext2fs_numeric_progress_update(fs,&progress, cur);
> +
> +		retval = io_channel_discard(fs->io, cur, count, fs->blocksize);
Here we need to limit 'count' within ext4's block range for the 1st 
round, otherwise it will discard the blocks outside our ext4 volume in 
case the size is less than 2GB.

Regards,
Tao
