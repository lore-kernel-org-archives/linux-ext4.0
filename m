From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs and fast symlink
Date: Mon, 24 Mar 2008 14:45:10 -0600
Message-ID: <20080324204510.GH2691@webber.adilger.int>
References: <20080321114234.GB6542@skywalker> <20080324113747.GA18042@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36129 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYCXUpU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 16:45:20 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2OKjIGF029961
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 13:45:19 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JY900K014WQMB00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 24 Mar 2008 13:45:18 -0700 (PDT)
In-reply-to: <20080324113747.GA18042@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 24, 2008  17:07 +0530, Aneesh Kumar K.V wrote:
> @@ -204,6 +204,14 @@ void ext4_delete_inode (struct inode * inode)
>  	if (inode->i_blocks)
>  		ext4_truncate(inode);
> +
> +	/*
> +	 * In case of link clear the extent flag. Fast symlinks are not
> +	 * stored in extent format we use i_blocks count to determine
> +	 * whether it is fast link or not.
> +	 */
> +	if (S_ISLNK(inode->i_mode))
> +		 EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;

This is a big hack I think.  It shouldn't matter to e2fsck whether a
deleted long symlink is in extent format or not, and clearing the flag
like this would make it harder to undelete this symlink if needed.  This
should be fixed in e2fsck and not the kernel.

Also, it is (IMHO) a hack that we use the i_blocks count to determine
if a symlink is fast or slow.  That is what caused the breakage when
EAs on symlinks were added, and if we add extra blocks to symlinks for
some other reason (e.g. more than a single EA block, or other) it will
break again.

Instead I propose that we just use the i_size itself to determine if
there is a fast symlink, because there has never (AFAIK) been a kernel
that created slow symlinks for files < 60 bytes in length.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

