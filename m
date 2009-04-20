From: Andreas Dilger <adilger@sun.com>
Subject: Re: Errors reported by Coverity in ext3
Date: Mon, 20 Apr 2009 16:14:41 -0600
Message-ID: <20090420221441.GI3209@webber.adilger.int>
References: <18730dc50904120458m1649aaf7tab395436d159105a@mail.gmail.com>
 <20090413220240.GT17302@webber.adilger.int>
 <18730dc50904160230ue3cbdccqd223e0a6f2edf06e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Amir Goldor <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60487 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZDTWO4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 18:14:56 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3KMEres015476
	for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2009 15:14:53 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIF004006QGZT00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Apr 2009 15:14:53 -0700 (PDT)
In-reply-to: <18730dc50904160230ue3cbdccqd223e0a6f2edf06e@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Thanks for the patch, unfortunately it is a NACK, since there are a few
bugs in the error handling, and some additional cleanups that can be done.

On Apr 16, 2009  12:30 +0300, Amir Goldor wrote:
> Also, the patch that you posted back in 2006 mostly handled
> jbd error check for "retaking write access" in ext3_clear_blocks().
> Do you have a newer patch for that? are you still using that old patch?

I don't recall which patch you refer to.

More comments inline.

> diff -up linux-2.6.28.orig/fs/ext3/namei.c linux-2.6.28/fs/ext3/namei.c
> --- linux-2.6.28.orig/fs/ext3/namei.c	2009-04-16 12:11:44.000000000 +0300
> +++ linux-2.6.28/fs/ext3/namei.c	2009-04-16 12:13:32.000000000 +0300
> @@ -1770,7 +1772,13 @@ static int ext3_mkdir(struct inode *dir
>  	BUFFER_TRACE(dir_block, "get_write_access");
> -	ext3_journal_get_write_access(handle, dir_block);
> +	err = ext3_journal_get_write_access(handle, dir_block);
> +	if (err) {
> +		drop_nlink(inode); /* is this nlink == 0? */
> +		ext3_mark_inode_dirty(handle, inode);
> +		iput (inode);
> +		goto out_stop;
> +	}

For the 2.6.29+ kernels you need to also include "unlock_new_inode(inode)"
after drop_nlink() in the error handling path.

It seems in all kernels you need to add "brelse(dir_block)" here as well,
because there was a reference gotten in ext3_bread() just above.  It might
be enough to do:

	if (err) {
		brelse(dir_block);
		goto out_clear_inode;
	}

> @@ -2302,7 +2310,9 @@ static int ext3_rename (struct inode * o
>  		BUFFER_TRACE(new_bh, "get write access");
> -		ext3_journal_get_write_access(handle, new_bh);
> +		retval = ext3_journal_get_write_access(handle, new_bh);
> +		if (retval)
> +			goto end_rename;

Similarly, this also needs a "brelse(new_bh)" before "goto end_rename".

> @@ -2360,7 +2370,14 @@ static int ext3_rename (struct inode * o
>  	ext3_update_dx_flag(old_dir);
>  	if (dir_bh) {
>  		BUFFER_TRACE(dir_bh, "get_write_access");
> +		retval = ext3_journal_get_write_access(handle, dir_bh);
> +		if (retval) {
> +			ext3_warning(old_dir->i_sb, "ext3_rename",
> +					"Updating new directory (%lu) parent link, %d, error=%d",
> +					new_dir->i_ino, new_dir->i_nlink, retval);
> +		}
> +	}

At this point, if we cannot get write access to the directory buffer, it
is really a bit too late to do much about it.  It may make more sense to
instead call ext3_journal_get_write_access() right after ext3_bread() is
called dor this buffer, so that the error can be checked and the rename
aborted before any changes are made.

Note also that there are some places where ext3_journal_dirty_metadata()
are called in these same code paths, but the error is not checked by the
caller.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

