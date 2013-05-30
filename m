From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/3] 285: Fix file syncing
Date: Thu, 30 May 2013 08:47:30 -0500
Message-ID: <51A75872.4080909@redhat.com>
References: <1369917939-22660-1-git-send-email-jack@suse.cz> <1369917939-22660-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab3E3Nre (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 May 2013 09:47:34 -0400
In-Reply-To: <1369917939-22660-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/30/13 7:45 AM, Jan Kara wrote:
> The intention of tests 08 and 09 in test generic/285 is to sync the
> whole file before checking for data and holes. However the helper is
> called with nbytes argument set to 0 which results in not syncing
> anything. Set nbytes properly.

Hm, are you sure? (Is the man page wrong, or is the sync_file_range
implementation wrong?)

DESCRIPTION
       sync_file_range()  permits  fine  control when synchronizing the
       open file referred to by the file descriptor fd with disk.

       offset is the starting byte of the file  range  to  be  synchro-
       nized.   nbytes specifies the length of the range to be synchro-
       nized, in bytes; if nbytes is zero, then all bytes  from  offset
       through to the end of file are synchronized.

-Eric

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  src/seek_sanity_test.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
> index eec6903..7d5868b 100644
> --- a/src/seek_sanity_test.c
> +++ b/src/seek_sanity_test.c
> @@ -229,7 +229,7 @@ static int test09(int fd, int testnum)
>  	 * Sync out dirty pages from bufsz * 100, this will convert
>  	 * the dirty page to writeback.
>  	 */
> -	ret = do_sync_dirty_pages(fd, bufsz * 100, 0);
> +	ret = do_sync_dirty_pages(fd, bufsz * 100, filsz);
>  	if (ret)
>  		goto out;
>  
> @@ -269,7 +269,7 @@ static int test08(int fd, int testnum)
>  		goto out;
>  
>  	/* Sync out all file */
> -	ret = do_sync_dirty_pages(fd, 0, 0);
> +	ret = do_sync_dirty_pages(fd, 0, filsz);
>  	if (ret)
>  		goto out;
>  
> 

