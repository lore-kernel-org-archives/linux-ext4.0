From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Wed, 19 Sep 2007 10:42:20 -0600
Message-ID: <20070919164220.GJ32520@schatzie.adilger.int>
References: <46F06C7B.20308@linux.vnet.ibm.com> <1190203577.14472.25.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, cmm@us.ibm.com, kalpak@clusterfs.com,
	girish@clusterfs.com
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:56563 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbXISQlz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 12:41:55 -0400
Content-Disposition: inline
In-Reply-To: <1190203577.14472.25.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 19, 2007  14:06 +0200, Valerie Clement wrote:
> I ran some tests with the uninit_groups feature enabled and got error messages
> when running e2fsck on my ext4 partition. e2fsck complains of an "invalid 
> unused inodes count" in some group descriptors.
> These errors occur when checking groups which have only one inode in use. The 
> "free inodes" count has been decremented by one in these groups but not the 
> "unused inodes" count.
> 
> Index: linux-2.6.23-rc6/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/fs/ext4/ialloc.c	2007-09-19 11:31:01.000000000 +0200
> +++ linux-2.6.23-rc6/fs/ext4/ialloc.c	2007-09-19 11:31:41.000000000 +0200
> @@ -633,13 +633,10 @@ got:
>  	/* If we didn't allocate from within the initialized part of the inode
>  	 * table then we need to initialize up to this inode. */
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
> -		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
> +		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
>  			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
> -			free = EXT4_INODES_PER_GROUP(sb);
> -		} else {
> -			free = EXT4_INODES_PER_GROUP(sb) -
> +		free = EXT4_INODES_PER_GROUP(sb) -
>  				le16_to_cpu(gdp->bg_itable_unused);
> -		}

Hmm, this is indeed incorrect, but I'm not sure solution is the right one.
I guess in our testing we ran it for a long time and must have created
more than a single inode per group...

What about the following instead?  I think the assumption in the original
code is that "it's a new group, all the inodes are free", but that is not
correct - we want to make NONE of the inodes free initially so that
bt_itable_unused is recalculated below:

		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-			free = EXT4_INODES_PER_GROUP(sb);
+			free = 0;
		} else {
			free = EXT4_INODES_PER_GROUP(sb) -
 				le16_to_cpu(gdp->bg_itable_unused);
		}

		 if (ino > free)
                       gdp->bg_itable_unused =
                                cpu_to_le16(EXT3_INODES_PER_GROUP(sb) - ino);

Still a bit uneasy about off-by-one errors here though.  Is "ino" 0 or
1 for the first inode in the group.  We might need to have a -1 in the
bg_itable_unused calculation still.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
