From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: Don't erase flash device if "-n" is given
Date: Tue, 07 Jun 2011 11:58:40 -0500
Message-ID: <4DEE58C0.3040303@redhat.com>
References: <1307463749-16498-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab1FGQ6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 12:58:45 -0400
In-Reply-To: <1307463749-16498-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/7/11 11:22 AM, Andreas Dilger wrote:
> If "mke2fs -n" is used, there should be no changes to the underlying
> device.  Unfortunately, when the "discard" option was added in commit
> c7cd908be59f48c66b4f3ac9a631ffe3dde4f1ab, it did not check for the "-n"
> flag, and will discard all data on a flash device even if "-n" is given.

Oh, crud.

> Check for the "noaction" flag before discarding any filesystem data.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  misc/mke2fs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index ddfa929..9472016 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2132,7 +2132,7 @@ int main (int argc, char *argv[])
>  	}
>  
>  	/* Can't undo discard ... */
> -	if (discard && (io_ptr != undo_io_manager)) {
> +	if (!noaction && discard && (io_ptr != undo_io_manager)) {
>  		retval = mke2fs_discard_device(fs);
>  		if (!retval && io_channel_discard_zeroes_data(fs->io)) {
>  			if (verbose)

