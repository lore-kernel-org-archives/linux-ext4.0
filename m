From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 15 Nov 2012 21:10:02 -0600
Message-ID: <50A5AE8A.6000707@redhat.com>
References: <50A546D8.3020500@redhat.com> <D4A8F4D6-0744-41E9-8339-1D0E1271F0E9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab2KPDOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 22:14:03 -0500
In-Reply-To: <D4A8F4D6-0744-41E9-8339-1D0E1271F0E9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/15/12 8:54 PM, Andreas Dilger wrote:
> On 2012-11-15, at 12:47 PM, Eric Sandeen wrote:
>> An index node's logical start (ei_block) should
>> match the logical start of the first node (index
>> or leaf) below it.  If we find a node whose start
>> does not match its parent, fix all of its parents
>> accordingly.
> 
> Eric,
> could you please provide some background on why you were looking at this
> and why it is a problem?  

Sure, sorry.  Should have provided more info.  And I need to provide
a test fs & testcase too.

This was from the recent  "wayland / chromium" thread; I got an e2image
from Tim which showed the problem.  The extent tree looked something
like this; this is from the debugfs dump_extents command.  (Note:
only the logical start & physical block are on disk; the end block &
length of interior nodes are inferred in debugfs from adjacent nodes):

Level Entries       Logical          Physical Length Flags
 0/ 1   1/  2     0 -  3665 1114157             3666
 1/ 1   1/ 59     0 -   132  510721 -  510853    133
...
 1/ 1  58/ 59  3039 -  3664  573440 -  574065    626
 1/ 1  59/ 59  3665 -  4092  574066 -  574493    428
 0/ 1   2/  2  3666 -  9217  395702             5552
 1/ 1   1/307  4093 -  4093  574494 -  574494      1
...

so in this case, the 2nd interior node claims to cover logical
blocks 3666 onwards, but the last extent in the previous interior
node covers 3665->4092 - overlapping the 2nd interior node's 
claimed range.

If we then try to write to block 3666, the search for its extent
yields:

Nov 12 17:41:52 inode kernel: EXT4-fs error (device loop0): ext4_ext_search_left: inode #274258: (comm flush-7:0) ix (3666) != EXT_FIRST_INDEX (0) (depth 0)!
Nov 12 17:41:52 inode kernel: EXT4-fs (loop0): delayed block allocation failed for inode 274258 at logical offset 3666 with max blocks 1 with error -5

because the search has gotten off track thanks to the wrong information
in the 2nd interior node.

> I could definitely understand that it would be
> a problem if the parent index did not cover the child extent, but if the
> parent extent is covering the child and has a "hole" at the start (maybe
> due to some extent there being punched out) does this confuse the extent
> handling logic in some manner?

So, what I found was when the extent under one interior node
overlapped with the range stated in another interior node.  Which can't
be good at all.

I'm not certain about the hole case, but AFAICT it should never happen,
from looking at the code.  ext4_ext_correct_indexes() seems 
to cover this in the kernel, and ext2fs_extent_fix_parents() in
userspace.

I did test the hole punching case, and the parents seem to get
adjusted.

I'm not 100% sure of the original design intent.  Is Alex still around? ;)

> I'd imagine that if there is a "hole" in the extent tree that it may get
> filled in some time later, so updating one or more parent extents during
> e2fsck will just need to be changed again later.  If I miss some obvious
> point, then maybe I'll end up a bit more informed from your explanation.

>From my reading of the code, the parent nodes should always start
at the same point as their first child.  I can see that more clearly
in the cases where it's explicitly set & fixed up after a change, but I
can't say for sure where (or if) it is required for proper functionality
elsewhere.

Thanks,
-Eric

> Cheers, Andreas
> 
>> If it finds such a problem, we'll see:
>>
>> Pass 1: Checking inodes, blocks, and sizes
>> Interior extent node level 0 of inode 274258:
>> Logical start 3666 does not match logical start 4093 at next level.  Fix<y>?
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> p.s. this works for me, but I am emphatically not an e2fsck
>> guru.  Please do review.  :)
>>
>> I'm not sure if this should trigger re-traversal of the
>> entire extent tree after the fixup?
>>
>> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
>> index a4bd956..7ff4021 100644
>> --- a/e2fsck/pass1.c
>> +++ b/e2fsck/pass1.c
>> @@ -1901,7 +1901,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
>> 		}
>>
>> 		if (problem) {
>> -		report_problem:
>> +report_problem:
>> 			pctx->blk = extent.e_pblk;
>> 			pctx->blk2 = extent.e_lblk;
>> 			pctx->num = extent.e_len;
>> @@ -1927,7 +1927,10 @@ fix_problem_now:
>> 		}
>>
>> 		if (!is_leaf) {
>> +			blk64_t lblk;
>> +
>> 			blk = extent.e_pblk;
>> +			lblk = extent.e_lblk;
>> 			pctx->errcode = ext2fs_extent_get(ehandle,
>> 						  EXT2_EXTENT_DOWN, &extent);
>> 			if (pctx->errcode) {
>> @@ -1940,6 +1943,18 @@ fix_problem_now:
>> 					goto report_problem;
>> 				return;
>> 			}
>> +			/* The next extent should match this index's logical start */
>> +			if (extent.e_lblk != lblk) {
>> +				struct ext2_extent_info info;
>> +
>> +				ext2fs_extent_get_info(ehandle, &info);
>> +				pctx->blk = lblk;
>> +				pctx->blk2 = extent.e_lblk;
>> +				pctx->num = info.curr_level - 1;
>> +				problem = PR_1_EXTENT_INDEX_START_INVALID;
>> +				if (fix_problem(ctx, problem, pctx))
>> +					ext2fs_extent_fix_parents(ehandle);
>> +			}
>> 			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
>> 			if (pctx->errcode)
>> 				return;
>> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
>> index 78b05bb..9d4cd5f 100644
>> --- a/e2fsck/problem.c
>> +++ b/e2fsck/problem.c
>> @@ -1000,6 +1000,14 @@ static struct e2fsck_problem problem_table[] = {
>> 	     "@i %i does not match.  "),
>> 	  PROMPT_FIX, 0 },
>>
>> +	/*
>> +	 * Interior extent node logical offset doesn't match first node below it
>> +	 */
>> +	{ PR_1_EXTENT_INDEX_START_INVALID,
>> +	  N_("Interior @x node level %N of @i %i:\n"
>> +	     "Logical start %b does not match logical start %c at next level.  "),
>> +	  PROMPT_FIX, 0 },
>> +
>> 	/* Pass 1b errors */
>>
>> 	/* Pass 1B: Rescan for duplicate/bad blocks */
>> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
>> index 5caade4..a57b104 100644
>> --- a/e2fsck/problem.h
>> +++ b/e2fsck/problem.h
>> @@ -586,6 +586,8 @@ struct problem_context {
>> /* ea block passes checks, but checksum invalid */
>> #define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
>>
>> +/* Index start doesn't match start of next extent down */
>> +#define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
>>
>> /*
>> * Pass 1b errors
>> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
>> index 9148d4e..ccd0936 100644
>> --- a/lib/ext2fs/ext2fs.h
>> +++ b/lib/ext2fs/ext2fs.h
>> @@ -1157,6 +1157,7 @@ extern errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
>> 					struct ext2_extent_info *info);
>> extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
>> 				    blk64_t blk);
>> +extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
>>
>> /* fileio.c */
>> extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
>> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
>> index da82a2a..8c3b7b9 100644
>> --- a/lib/ext2fs/extent.c
>> +++ b/lib/ext2fs/extent.c
>> @@ -722,7 +722,7 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
>> * Safe to call for any position in node; if not at the first entry,
>> * will  simply return.
>> */
>> -static errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
>> +errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
>> {
>> 	int				retval = 0;
>> 	blk64_t				start;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

