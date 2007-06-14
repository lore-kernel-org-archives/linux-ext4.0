From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: inode version updates
Date: Thu, 14 Jun 2007 03:53:59 -0600
Message-ID: <20070614095359.GJ5181@schatzie.adilger.int>
References: <1181782962.13428.26.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44810 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXFNJyB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 05:54:01 -0400
Received: from localhost.adilger.int (S0106000bdb95b39c.cg.shawcable.net [70.72.213.136])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id 3A4767BA318
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2007 03:54:00 -0600 (MDT)
Content-Disposition: inline
In-Reply-To: <1181782962.13428.26.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao <cmm@us.ibm.com> writes:
> I took out the i_version code from Kalpak's
> ext4_expand_inode_extra_isize.patch. 
>
> http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4_i_version_hi_2.patch;h=4519dd6540a78cadd235dad68248456d59c3384c;hb=8b956b5c5ccc3731f23fbce8d036b21f378fbdec
>
> Added Jean noel's inode version VFS patch and Ext4 patches. Now the full
> inode version patch series can be found at ext4 patch queue:
> 
> # inode verion patch series
> # inode versioning is needed for NFSv4
> 
> # vfs changes, 64 bit inode->i_version
> i_version_update_vfs.patch

Looking through this, I don't understand why there are i_version updates
in the VFS?  The comments here imply that this is only for filesystems
which will never be mounted (e.g. pipefs).  Having i_version updates there
is confusing and I don't think it helps anyone.

> # ext4 inode version update
> i_version_update_ext4.patch
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c       2007-06-13 17:19:11.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c    2007-06-13 17:24:45.000000000 -0700
> @@ -2846,8 +2846,8 @@ out:
>                i_size_write(inode, off+len-towrite);
>                EXT4_I(inode)->i_disksize = inode->i_size;
>        }
>-       inode->i_version++;
>        inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>+       inode->i_version = 1;
>        ext4_mark_inode_dirty(handle, inode);
>        mutex_unlock(&inode->i_mutex);
>        return len - towrite;

The change from "i_version++" to "i_version = 1" in ext4_update_quota()
is confusing.  Why was this change made?  If there is a good reason why
the inode version stays at 1 for the quota file, maybe it deserves
a comment explaining it.


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
