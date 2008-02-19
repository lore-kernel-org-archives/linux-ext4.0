From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Tue, 19 Feb 2008 22:19:44 +0530
Message-ID: <20080219164944.GB7177@skywalker>
References: <47B9F1F1.30604@redhat.com> <47BB0658.90204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58171 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYBSQtx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 11:49:53 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1JGnaZf007298
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 03:49:36 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JGnoAa3608818
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 03:49:50 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JGnorJ030354
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 03:49:50 +1100
Content-Disposition: inline
In-Reply-To: <47BB0658.90204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 10:39:52AM -0600, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > e2fsck doesn't expect to find char, block, fifo, or socket
> > files with the extent flag set, so clear that in ext4_mknod.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > Index: linux-2.6.24/fs/ext4/namei.c
> > ===================================================================
> > --- linux-2.6.24.orig/fs/ext4/namei.c
> > +++ linux-2.6.24/fs/ext4/namei.c
> > @@ -1766,6 +1766,7 @@ retry:
> >  #ifdef CONFIG_EXT4DEV_FS_XATTR
> >  		inode->i_op = &ext4_special_inode_operations;
> >  #endif
> > +		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
> >  		err = ext4_add_nondir(handle, dentry, inode);
> >  	}
> >  	ext4_journal_stop(handle);
> 
> now that I think about it; perhaps it would be better to put this logic
> into ext4_new_inode, rather than setting it by default and clearing it
> here... that way new_inode() has all the logic about whether or not a
> particular type of file is in extents format.
> 

How about enabling it only for directory and regular files rather than
enabling it globally and then disabling the flag for  symlink and device
files ?

-aneesh
