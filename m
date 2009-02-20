From: Xiang Wang <xiangw@google.com>
Subject: fsck errors encountered when applying patch "ext4: fix BUG when
	calling ext4_error with locked block group"
Date: Fri, 20 Feb 2009 15:31:36 -0800
Message-ID: <d5ca277e0902201531g6e32691cweda3fd8f6d1dbbff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Michael Rubin <mrubin@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Chad Talbott <ctalbott@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:9713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269AbZBTXbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2009 18:31:39 -0500
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n1KNVcHi017702
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 15:31:38 -0800
Received: from rv-out-0506.google.com (rvbl9.prod.google.com [10.140.88.9])
	by wpaz21.hot.corp.google.com with ESMTP id n1KNVNnL014342
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 15:31:36 -0800
Received: by rv-out-0506.google.com with SMTP id l9so1141890rvb.3
        for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 15:31:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are recently picking some patches selectively from the ext4-stable
branch of the ext4 git tree and applied them to our internal ext4
tree(mostly based on a 2.6.26 kernel with some of our own changes),
and when we applied the following patch:

"ext4: fix BUG when calling ext4_error with locked block group"
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=be8f3df12cddeb352dd624fba9bf46a2de5711f3

We hit filesystem errors reported by fsck after we run dbench, an
example of the error is as follows:
// run dbench
dbench complete!
starting fsck...
e2fsck 1.41.3 (12-Oct-2008)
/dev/hdk3 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free inodes count wrong (45793274, counted=45793269).
Fix? no


/dev/hdk3: ********** WARNING: Filesystem still has errors **********

/dev/hdk3: 6/45793280 files (0.0% non-contiguous), 2891716/183143000 blocks

This problem seems to be the number of free inodes stored in the ext4
super block does not match the number counted by reading the inode
bitmaps.

Then I looked into the patch, especially the diff in the
ext4_commit_super in fs/ext4/super.c
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=blobdiff;f=fs/ext4/super.c;h=c53cab1e0a7fca1d9406f9bbb7c9cb661bae0567;hp=ed0406de6cae7379df9f72f272ade1a18df3966b;hb=be8f3df12cddeb352dd624fba9bf46a2de5711f3;hpb=e8470671cf71ec6361b71b3c95a1a1392c5cfa75

@@ -2868,8 +2906,11 @@ static void ext4_commit_super(struct super_block *sb,
                set_buffer_uptodate(sbh);
        }
        es->s_wtime = cpu_to_le32(get_seconds());
-       ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
-       es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
+       ext4_free_blocks_count_set(es, percpu_counter_sum_positive(
+                                       &EXT4_SB(sb)->s_freeblocks_counter));
+       es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
+                                       &EXT4_SB(sb)->s_freeinodes_counter));
+
        BUFFER_TRACE(sbh, "marking dirty");
        mark_buffer_dirty(sbh);
        if (sync) {

seems like the new code only looks into the s_freeinodes_counter field
while the old code calls ext4_count_free_inodes(sb) and calculates the
count by adding up the free inode number from each block group.

So I tried reverting this particular portion of the patch, and reran
the dbench with the newly built kernel a couple of times, and the fsck
showed the file system to be clean.

I am just curious to see if anyone has ever seen this problem as I do
and whether there is a later fix for this. Of course, since I did not
apply all the patches from the ext4-stable branch, nor did I apply
patches on a public ext4 tree(I am only working on our internal tree),
that might already be a big problem. Still I would like to see why my
reverting this portion of the patch seems to be a temporarily fix?

thanks,
Xiang
