From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Error with the latest stable series of the patch queue.
Date: Tue, 19 Feb 2008 22:57:49 +0530
Message-ID: <20080219172749.GE7177@skywalker>
References: <20080219152136.GA7177@skywalker> <47BB0E95.1000606@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34250 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753116AbYBSR1w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 12:27:52 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1JHRolo029067
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 22:57:50 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JHRoDR790740
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 22:57:50 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1JHRnkC028378
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 17:27:49 GMT
Content-Disposition: inline
In-Reply-To: <47BB0E95.1000606@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 19, 2008 at 06:15:01PM +0100, Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>> Hi all,
>>
>> I am seeing the below error in the console. But the tests are reported
>> as success.
>>
>> EXT4-fs: mballoc enabled
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204044: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204045: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204047: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204056: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204061: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204065: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204068: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204069: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204071: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
>> EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
>> #204077: invalid magic - 
>>
> Hi Aneesh,
>
> I've got also several issues while running ffsb tests today. The tests
> ended with success but e2fsck reported an error:
>
>  Pass 1: Checking inodes, blocks, and sizes
>  Inode 3367164, i_size is 57380864, should be 57442304.  Fix?
>
> Inode 3367164 is allocated in the last group of the filesystem.
>
> As I changed the allocation algorithm for the last group in the patch
> "ext4_fix_block_alloc_algorithm_for_last_group.patch", I removed this
> patch and ran again the same test. I didn't reproduce the issue.
>
> *But* I reproduced it on a filesystem created with a smaller block size
> value (= 1024 instead of 4096 previously) and with a kernel *without*
> my patch applied. e2fsck reports the same error on inodes created in the
> last group. Sometimes in this configuration, error messages are also
> displayed on the console:
>
> EXT4-fs error (device sdc): ext4_valid_block_bitmap: Invalid block bitmap 
> - block_group = 7358, block = 60276737
> EXT4-fs error (device sdc): ext4_valid_block_bitmap: Invalid block bitmap 
> - block_group = 7358, block = 60276737
>
> and e2fsck reports errors like:
> Inode 2113777 has corrupt extent index at block 61165699 (logical -1) entry 0
> Fix?
>
> So, there is a problem when allocating inodes in the last group:
> - without my patch when block size value is 1024,
> - with my patch when block size value is 4096.
>
> Could you check if your tests allocate inodes in the last group and run
> also e2fsck to see if it reports errors.
>
>

Can you run the test with the below patch on top of stable series.


diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d2c2e55..14fb73b 100644
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
@@ -836,13 +841,16 @@ got:
 		ext4_std_error(sb, err);
 		goto fail_free_drop;
 	}
-	if (test_opt(sb, EXTENTS) && !S_ISLNK(mode)) {
-		EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
-		ext4_ext_tree_init(handle, inode);
-		err = ext4_update_incompat_feature(handle, sb,
-						EXT4_FEATURE_INCOMPAT_EXTENTS);
-		if (err)
-			goto fail;
+	if (test_opt(sb, EXTENTS)) {
+		/* set extent flag only for diretory and file */
+		if (S_ISDIR(mode) || S_ISREG(mode)) {
+			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
+			ext4_ext_tree_init(handle, inode);
+			err = ext4_update_incompat_feature(handle, sb,
+					EXT4_FEATURE_INCOMPAT_EXTENTS);
+			if (err)
+				goto fail;
+		}
 	}
 
 	ext4_debug("allocating inode %lu\n", inode->i_ino);
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
>
>
>
>
>
>
>
>
