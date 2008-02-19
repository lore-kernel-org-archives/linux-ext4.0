From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] clear extents flag on inodes created in ext4_mknod
Date: Tue, 19 Feb 2008 22:35:12 +0530
Message-ID: <20080219170512.GC7177@skywalker>
References: <47B9F1F1.30604@redhat.com> <47BB0658.90204@redhat.com> <20080219164944.GB7177@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59281 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbYBSRFV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 12:05:21 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1JH67FO012799
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 04:06:07 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JH5I8j1810592
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 04:05:18 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JH5ITY011081
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 04:05:18 +1100
Content-Disposition: inline
In-Reply-To: <20080219164944.GB7177@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 10:19:44PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Feb 19, 2008 at 10:39:52AM -0600, Eric Sandeen wrote:
> > Eric Sandeen wrote:
> > > e2fsck doesn't expect to find char, block, fifo, or socket
> > > files with the extent flag set, so clear that in ext4_mknod.
> > > 
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > ---
> > > 
> > > Index: linux-2.6.24/fs/ext4/namei.c
> > > ===================================================================
> > > --- linux-2.6.24.orig/fs/ext4/namei.c
> > > +++ linux-2.6.24/fs/ext4/namei.c
> > > @@ -1766,6 +1766,7 @@ retry:
> > >  #ifdef CONFIG_EXT4DEV_FS_XATTR
> > >  		inode->i_op = &ext4_special_inode_operations;
> > >  #endif
> > > +		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
> > >  		err = ext4_add_nondir(handle, dentry, inode);
> > >  	}
> > >  	ext4_journal_stop(handle);
> > 
> > now that I think about it; perhaps it would be better to put this logic
> > into ext4_new_inode, rather than setting it by default and clearing it
> > here... that way new_inode() has all the logic about whether or not a
> > particular type of file is in extents format.
> > 
> 
> How about enabling it only for directory and regular files rather than
> enabling it globally and then disabling the flag for  symlink and device
> files ?
> 

how about something like below. There are two reason for not inheriting
the i_flag from directory.


a) if the directory have extent flag set we end up with symlink which
have extent flag set but on which ext4_ext_tree_init is not called.

b) if we create a directory with extent flag and later mount the file
system with -o noextents, the files created in that directory will also
have extent flag set but we would not have called ext4_ext_tree_init for
them.

Both results in the stack below which cause ext4_error.

Call Trace:
[c00000002c937320] [c0000000001a0b84] .ext4_ext_find_extent+0x74/0x344 (unreliable)
[c00000002c9373e0] [c0000000001a32c0] .ext4_ext_get_blocks+0x1e8/0xc3c
[c00000002c937570] [c000000000191394] .ext4_get_blocks_wrap+0xa4/0x19c
[c00000002c937640] [c000000000191588] .ext4_get_block+0xfc/0x16c
[c00000002c937700] [c00000000011490c] .__block_prepare_write+0x1f0/0x4f8
[c00000002c937810] [c000000000114e5c] .block_write_begin+0xc4/0x160
[c00000002c9378e0] [c00000000018ec28] .ext4_write_begin+0x12c/0x24c
[c00000002c9379e0] [c0000000000a7ef4] .pagecache_write_begin+0x84/0x1e0
[c00000002c937ac0] [c0000000000f17f8] .__page_symlink+0x6c/0x154
[c00000002c937b80] [c00000000019784c] .ext4_symlink+0x1d8/0x2b8
[c00000002c937c60] [c0000000000f0508] .vfs_symlink+0x130/0x1c8
[c00000002c937d00] [c0000000000f0648] .sys_symlinkat+0xa8/0x110
[c00000002c937e30] [c00000000000872c] syscall_exit+0x0/0x40


and console message:

EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204044: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)




diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d2c2e55..f430939 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -794,7 +794,12 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	ei->i_flags = EXT4_I(dir)->i_flags & ~EXT4_INDEX_FL;
+	/*
+	 * Don't inherit extent flag from directory. We set extent flag on
+	 * newly created directory and file only if -o extent mount option is
+	 * specfied
+	 */
+	ei->i_flags = EXT4_I(dir)->i_flags & ~ (EXT4_INDEX_FL|EXT4_EXTENTS_FL);
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
@@ -836,8 +841,10 @@ got:
 		ext4_std_error(sb, err);
 		goto fail_free_drop;
 	}
-	if (test_opt(sb, EXTENTS) && !S_ISLNK(mode)) {
-		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
+	if (test_opt(sb, EXTENTS)) {
+		/* set extent flag only for diretory and file */
+		if (S_ISDIR(mode) || S_ISREG(mode))
+			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
 		ext4_ext_tree_init(handle, inode);
 		err = ext4_update_incompat_feature(handle, sb,
 						EXT4_FEATURE_INCOMPAT_EXTENTS);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 23902ba..da942bc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1771,7 +1771,6 @@ retry:
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
 #endif
-		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);
