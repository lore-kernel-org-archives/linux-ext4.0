From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [patch 1/1] fs/ext4/fsync.c: generic_file_fsync call based on
 barrier flag
Date: Mon, 23 Jun 2014 12:41:04 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406231229320.2169@localhost.localdomain>
References: <20140606195150.728635A45DE@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, fabf@skynet.be,
	hch@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbaFWKll (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jun 2014 06:41:41 -0400
In-Reply-To: <20140606195150.728635A45DE@corp2gmr1-2.hot.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 6 Jun 2014, akpm@linux-foundation.org wrote:

> Date: Fri, 06 Jun 2014 12:51:50 -0700
> From: akpm@linux-foundation.org
> To: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be,
>     hch@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk
> Subject: [patch 1/1] fs/ext4/fsync.c: generic_file_fsync call based on barrier
>      flag
> 
> From: Fabian Frederick <fabf@skynet.be>
> Subject: fs/ext4/fsync.c: generic_file_fsync call based on barrier flag
> 
> generic_file_fsync has been updated to issue a flush for older
> filesystems.
> 
> This patch tests for barrier flag in ext4 mount flags and calls the right
> function.

The patch itself looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Note that the actual generic_file_fsync change fixes a real bug
in ext4 where we would _not_ send a flush on sync if we have file
system without journal.

Ted, it would be useful to mention that in the commit description
along with the commit id:

ac13a829f6adb674015ab399594c089990104af7 fs/libfs.c: add generic
data flush to fsync

Thanks!
-Lukas

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ext4/fsync.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff -puN fs/ext4/fsync.c~fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag fs/ext4/fsync.c
> --- a/fs/ext4/fsync.c~fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag
> +++ a/fs/ext4/fsync.c
> @@ -107,7 +107,10 @@ int ext4_sync_file(struct file *file, lo
>  	}
>  
>  	if (!journal) {
> -		ret = generic_file_fsync(file, start, end, datasync);
> +		if (test_opt(inode->i_sb, BARRIER))
> +			ret = generic_file_fsync(file, start, end, datasync);
> +		else
> +			ret = __generic_file_fsync(file, start, end, datasync);
>  		if (!ret && !hlist_empty(&inode->i_dentry))
>  			ret = ext4_sync_parent(inode);
>  		goto out;
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
