From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: *** SPAM *** Re: [PATCH] e2fsck: improve performance of
 region_allocate()
Date: Tue, 22 Aug 2017 15:47:25 +0200
Message-ID: <00f408c1-215e-39e2-dec4-8f05eb604f97@uls.co.za>
References: <20170819011635.1815929-1-dsp@fb.com>
 <20170822022948.nyn6fessudjaj5xh@thunk.org>
 <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
 <20170822124505.xr7wnxonsbml3mgh@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A7179380ECEC86882D0D1753"
Cc: Doug Porter <dsp@fb.com>, linux-ext4@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from othala.uls.co.za ([154.73.34.12]:58553 "EHLO othala.uls.co.za"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932512AbdHVNrt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Aug 2017 09:47:49 -0400
In-Reply-To: <20170822124505.xr7wnxonsbml3mgh@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------A7179380ECEC86882D0D1753
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ted,

On 22/08/2017 14:45, Theodore Ts'o wrote:
>> The attached improves CPU performance from O(e*h) to O(e) and memory from
>> O(h) to O(1).  The patch below does similar for CPU but nothing for memory
>> (In my case it took fsck down by a significant margin).
> I thought you were saying you had some false positives (where it was
> causing e2fsck to complain about some valid extent trees in your file
> system)?  That's why I've not acted on your proposed patch until I had
> time to study the code more closely to understand what was going on
> with the errors I thought you had reported.
I did in fact manage to clear it, but raised it so that you could 
confirm.  With all three patches I sent you directly applied:

338 tests succeeded     0 tests failed

> As far as the other (icount) optimization is concerned, that's on my
> todo list but I'm trying to understand how much of a win it's going to
> be on a densly hard linked file system, and whether the complexity due
> to the handling the potential increased memory usage is worth it.  If
> we leave to be something that has to be manually enabled using
> /etc/e2fsck.conf, very few people will use it.  If we need to somehow
> figure out how it's safe / necessary to activate the icount
> optimization, especially if there are potentially multiple fsck's
> running in parallel, this starts to get really complicated.  So
> perhaps all we can do is leave it as a manually enabled option, but I
> still need to think about that a bit.
My (purely theoretical) assessment on that (attached - proof-of-concept 
quality at best) below.

n = the number of files with a link count > 1;
t = the total number of possible inodes;
g = sum of link counts for all inodes with link count >1; and
c = the average link-count for inodes with link count >1 (g/n).

my case n = ~100 million and t = ~2.8 billion.  I don't have an estimate 
of g for my system, but reckon it can be in the range of 2 billion quite 
trivially.

Pass1 assessment:  insertions are always onto the end of the list 
(inodes traversed sequentially), and cpu and memory wise reduces to O(n) 
(memory = 96/8 * n = 12n bytes, 1.2GB in my case).  I don't think there 
is improvements to be had during pass1.

Pass2, current code:  we clone the list of inodes with link-count>1, 
avoiding expensive mid-array insertions, this reduces to a really fast 
O(n).  "increments" are expensive, and each increment results in a 
binary search for the correct entry in the array, costing O(log(n)) - 27 
comparison ops for my 40TB filesystem.  We perform this g number of 
times, so overall cpu is O(g.log(n)).  memory remains identical to above.

Pass2, full map (possible "optimization"):

We allocate an array of __u16 for t inodes.  In my use-case this 
requires 2.8bn index size, or 5.6GB RAM.  Memory *normally* goes up to O(t).

Only if n > 16.7% of t does memory usage decrease - based on the fact 
that my filesystem has average file size of 394KB, and is <1TB remaining 
on a 40TB file system at 107m files, n/t in my case = 3.5%, I find this 
use-case extremely unlikely.  We can thus argue we ALWAYS sacrifice 
memory, from O(n) to O(t).

In terms of CPU however the increase operation now becomes O(1), from 
O(log(n)).  Depending on the value of g this can be a huge gain, and 
since the O(1) here is a VERY FAST O(1) I suspect the 27x factor in my 
use-case is an underestimate of the actual factor (I suspect even if we 
have only 1 entry in the list the fact that we have to go through just 
one search iteration is at least 3-5x more expensive in terms of the 
constant, thus I *suspect* that a sensible cpu speedup for this check 
for comparing link counts in inodes compared to actual directory 
structures is probably around 100x during pass2.  I could very well be 
wrong.

That said, assuming that we will need to go out to disk to retrieve 
directory structures we're probably going to be IO bound at this point 
anyway, but you're the better person to comment on how disk/cpu bound 
pass2 is in general at this stage.

Performing CPU benchmarks that doesn't require disk should be relatively 
trivial (iterate through a set of values for n and g and generate random 
data - at no point does the cpu utilization depend on the value of t, so 
we can measure the effective difference on even super-crazy values of n 
and g (constrained by g <= n*Max_Link_Count).  If this is something that 
would be interesting I'll happily see if I can generate something.

My opinion: if pass2 is currently generally CPU bound for such use-cases 
we should look at this further, if disk bound then there is no point.  
We can easily calculate the values of n, t and g during pass1 (or even 
as setup code for pass2, everything we need is available to icount.c 
during construction time of pass2 data structure).  Perhaps it makes 
sense to switch to full_map implementation heuristically based on those 
values, but we'd need to understand the potential impact.  We can 
trivially fail back to the current implementation if the memory 
allocation fails.

Kind Regards,
Jaco

--------------A7179380ECEC86882D0D1753
Content-Type: text/x-patch;
 name="0002-e2fsck-add-optimization-for-heavy-hard-linked-pass2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-e2fsck-add-optimization-for-heavy-hard-linked-pass2.pat";
 filename*1="ch"

>From b6e80fedf35a9953d0c00b5ca2353d3bec1121f0 Mon Sep 17 00:00:00 2001
From: Jaco Kroon <jaco@uls.co.za>
Date: Tue, 15 Aug 2017 18:38:47 +0200
Subject: [PATCH 2/3] e2fsck: add optimization for heavy-hard-linked pass2.

In the case of heave hard-linking pass2 can slow down rapidly due to
binary search lookup of inode numbers.  This implements a memory
trade-off (storing 2 bytes in-memory for each inode to keep counts).

For a 40TB filesystem with 2.8bn inodes this map alone requires 5.7GB of
RAM.  We don't activate this for pass1 since the gain CPU gain is nearly
nil for that pass and the sacrificed memory does not justify the
increase in RAM.

It could be that during pass1 if more than 17% if possible inodes has
link_count>1 (466m inodes in the 40TB with 2.8bn possible inodes case)
then it becomes more memory efficient to use the full map implementation
in terms of memory.

The author of this patch believes that to be an extremely unlikely
use-case scenario.
---
 e2fsck/pass1.c      |  6 ++++-
 lib/ext2fs/ext2fs.h |  1 +
 lib/ext2fs/icount.c | 64 +++++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 47a8b27c..97dd79c4 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -817,6 +817,7 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
 	errcode_t		retval;
 	char			*tdb_dir;
 	int			enable;
+	int			full_map;
 
 	*ret = 0;
 
@@ -826,6 +827,8 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
 			 "numdirs_threshold", 0, 0, &threshold);
 	profile_get_boolean(ctx->profile, "scratch_files",
 			    "icount", 0, 1, &enable);
+	profile_get_boolean(ctx->profile, "full_map",
+			"enable", 0, 1, &full_map);
 
 	retval = ext2fs_get_num_dirs(ctx->fs, &num_dirs);
 	if (retval)
@@ -840,7 +843,8 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
 	}
 	e2fsck_set_bitmap_type(ctx->fs, EXT2FS_BMAP64_RBTREE, icount_name,
 			       &save_type);
-	retval = ext2fs_create_icount2(ctx->fs, flags, 0, hint, ret);
+	retval = ext2fs_create_icount2(ctx->fs, flags | (full_map ? EXT2_ICOUNT_OPT_FULLMAP : 0),
+			0, hint, ret);
 	ctx->fs->default_bitmap_type = save_type;
 	return retval;
 }
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a2c8edaa..a4feaccc 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -546,6 +546,7 @@ typedef struct ext2_struct_inode_scan *ext2_inode_scan;
  * ext2_icount_t abstraction
  */
 #define EXT2_ICOUNT_OPT_INCREMENT	0x01
+#define EXT2_ICOUNT_OPT_FULLMAP		0x02
 
 typedef struct ext2_icount *ext2_icount_t;
 
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index 594b1cc2..7fcd0432 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -61,6 +61,7 @@ struct ext2_icount {
 	char			*tdb_fn;
 	TDB_CONTEXT		*tdb;
 #endif
+	__u16			*fullmap;
 };
 
 /*
@@ -93,6 +94,9 @@ void ext2fs_free_icount(ext2_icount_t icount)
 	}
 #endif
 
+	if (icount->fullmap)
+		ext2fs_free_mem(&icount->fullmap);
+
 	ext2fs_free_mem(&icount);
 }
 
@@ -108,10 +112,20 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 		return retval;
 	memset(icount, 0, sizeof(struct ext2_icount));
 
+	if (flags & EXT2_ICOUNT_OPT_FULLMAP && flags & EXT2_ICOUNT_OPT_INCREMENT) {
+		retval = ext2fs_get_mem(sizeof(__u32) * fs->super->s_inodes_count, &icount->fullmap);
+		/* If we can't allocate, fall back */
+		if (!retval) {
+			memset(icount->fullmap, 0, sizeof(__u32) * fs->super->s_inodes_count);
+			goto successout;
+		}
+	}
+
 	retval = ext2fs_allocate_inode_bitmap(fs, "icount", &icount->single);
 	if (retval)
 		goto errout;
 
+
 	if (flags & EXT2_ICOUNT_OPT_INCREMENT) {
 		retval = ext2fs_allocate_inode_bitmap(fs, "icount_inc",
 						      &icount->multiple);
@@ -120,6 +134,7 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 	} else
 		icount->multiple = 0;
 
+successout:
 	icount->magic = EXT2_ET_MAGIC_ICOUNT;
 	icount->num_inodes = fs->super->s_inodes_count;
 
@@ -256,6 +271,9 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags, unsigned int size,
 	if (retval)
 		return retval;
 
+	if (icount->fullmap)
+		goto successout;
+
 	if (size) {
 		icount->size = size;
 	} else {
@@ -295,6 +313,7 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags, unsigned int size,
 		icount->count = hint->count;
 	}
 
+successout:
 	*ret = icount;
 	return 0;
 
@@ -433,6 +452,11 @@ static errcode_t set_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 		return 0;
 	}
 #endif
+	if (icount->fullmap) {
+		icount->fullmap[ino] = icount_16_xlate(count);
+		return 0;
+	}
+
 	el = get_icount_el(icount, ino, 1);
 	if (!el)
 		return EXT2_ET_NO_MEMORY;
@@ -463,6 +487,11 @@ static errcode_t get_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 		return 0;
 	}
 #endif
+	if (icount->fullmap) {
+		*count = icount->fullmap[ino];
+		return 0;
+	}
+
 	el = get_icount_el(icount, ino, 0);
 	if (!el) {
 		*count = 0;
@@ -504,14 +533,16 @@ errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
-		*ret = 1;
-		return 0;
-	}
-	if (icount->multiple &&
-	    !ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
-		*ret = 0;
-		return 0;
+	if (!icount->fullmap) {
+		if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
+			*ret = 1;
+			return 0;
+		}
+		if (icount->multiple &&
+			!ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
+			*ret = 0;
+			return 0;
+		}
 	}
 	get_inode_count(icount, ino, &val);
 	*ret = icount_16_xlate(val);
@@ -528,7 +559,9 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
+	if (icount->fullmap) {
+		curr_value = icount->fullmap[ino] = icount_16_xlate(icount->fullmap[ino] + 1);
+	} else if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		/*
 		 * If the existing count is 1, then we know there is
 		 * no entry in the list.
@@ -585,6 +618,16 @@ errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
+	if (icount->fullmap) {
+		if (!icount->fullmap[ino])
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		curr_value = --icount->fullmap[ino];
+		if (ret)
+			*ret = icount_16_xlate(curr_value);
+		return 0;
+	}
+
 	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		ext2fs_unmark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple)
@@ -626,6 +669,9 @@ errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
+	if (icount->fullmap)
+		return set_inode_count(icount, ino, count);
+
 	if (count == 1) {
 		ext2fs_mark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple)
-- 
2.13.3


--------------A7179380ECEC86882D0D1753--
