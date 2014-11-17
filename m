From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/3] e2fsprogs/tune2fs: rewrite metadata checksums
 when resizing inode size
Date: Mon, 17 Nov 2014 09:56:27 +0800
Message-ID: <546955CB.5090101@cn.fujitsu.com>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com> <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com> <20141114231010.GK10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------070806000001040908050108"
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61855 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753302AbaKQB6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Nov 2014 20:58:55 -0500
In-Reply-To: <20141114231010.GK10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--------------070806000001040908050108
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

On 11/15/2014 07:10 AM, Darrick J. Wong wrote:
> On Fri, Nov 14, 2014 at 05:15:36PM +0800, Xiaoguang Wang wrote:
>> When we use tune2fs -I new_ino_size to change inode size, if everything is OK,
>> the corresponding ext4_group_desc.bg_free_blocks_count will be decreased, so
>> obviously, we need to re-compute the group descriptor checksums, and the inode
>> 's size has also changed, we also need to recompute the checksums of inodes for
>> metadata_csum filesystem, so here we choose to call a rewrite_metadata_checksums(),
>> this will fix checksum issues.
>>
>> Meanwhile, the patch will trigger an existing memory write overflow, which will
>> casue segfault, please see the next patch.
>>
>> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  misc/tune2fs.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>> index 065b483..91dc7c1 100644
>> --- a/misc/tune2fs.c
>> +++ b/misc/tune2fs.c
>> @@ -2908,8 +2908,7 @@ retry_open:
>>  				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>>  			rewrite_checksums = 1;
>>  	}
>> -	if (rewrite_checksums)
>> -		rewrite_metadata_checksums(fs);
>> +
>>  	if (I_flag) {
>>  		if (mount_flags & EXT2_MF_MOUNTED) {
>>  			fputs(_("The inode size may only be "
>> @@ -2935,6 +2934,7 @@ retry_open:
>>  		if (resize_inode(fs, new_inode_size) == 0) {
> 
> Come to think of it, if we're enabling metadata_csum /and/ resizing the inode,
> we have to set EXT2_FLAG_IGNORE_CSUM_ERRORS before calling resize_inode.  If we
> don't, the library calls that resize_inode() makes will try to verify the
> checksums (which haven't been set yet) and the operation will fail.

Aha, right, sorry!
> 
> Will send patch, but at this point I'm wondering if it doesn't make more sense
> for me to incorporate them into my patchbomb rather than let this series get
> lost in the blizzard...

OK, it would be better for you to incorporate them into your patchbomb, thanks!
Also I attached one filefrag's bug fix, please incorporate it too :)

Regards,
Xiaoguang Wang
> 
> --D
> 
>>  			printf(_("Setting inode size %lu\n"),
>>  							new_inode_size);
>> +			rewrite_checksums = 1;
>>  		} else {
>>  			printf("%s", _("Failed to change inode size\n"));
>>  			rc = 1;
>> @@ -2942,6 +2942,9 @@ retry_open:
>>  		}
>>  	}
>>  
>> +	if (rewrite_checksums)
>> +		rewrite_metadata_checksums(fs);
>> +
>>  	if (l_flag)
>>  		list_super(sb);
>>  	if (stride_set) {
>> -- 
>> 1.8.2.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 


--------------070806000001040908050108
Content-Type: text/x-patch;
	name="0001-filefrag-fix-wrong-extent-count-calculation-when-usi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-filefrag-fix-wrong-extent-count-calculation-when-usi.pa";
	filename*1="tch"

>From caf9da020d1bb67fac20cee2a020dd3cc33777ec Mon Sep 17 00:00:00 2001
From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Date: Tue, 7 Oct 2014 16:31:17 +0800
Subject: [PATCH] filefrag: fix wrong extent count calculation when using
 FIBMAP

When using FIBMAP and '-e' option is specified, the calculation for fiemap_extent
is wrong, we wrongly updated fm_ext.fe_logical for every iteration, please see the
code in the end of 'for' loop in fm_ext.fe_logical().

In an ext2 file system(block size is 1024 bytes),
  dd if=/dev/zero of=testfile bs=1k count=15
  Using debugfs, corresponding physical blocks are "2049 2050 2051 2052 2053 2054
2055 2056 2057 2058 2059 2060 1025 2061 2062 2063",  1025 is this indirect block.
Before this patch, filefrag's output would be:
  filefrag -B -e testfile
  Filesystem type is: ef53
  Filesystem cylinder groups approximately 16
  File size of testfile is 15360 (15 blocks of 1024 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        1..       2:       2050..      2051:      2:       2051: merged
     1:        3..       4:       2052..      2053:      2:       2053: merged
     2:        5..       6:       2054..      2055:      2:       2055: merged
     3:        7..       8:       2056..      2057:      2:       2057: merged
     4:        9..      10:       2058..      2059:      2:       2059: merged
     5:       11..      12:       2060..      2061:      2:       2062: merged
     6:       13..      14:       2062..      2063:      2:       2063: merged,eof
     7:       14..      14:       2063..      2063:      1:       2063: merged,eof
This output is not reasonable.

Fix this bug and try to make it readable. With this patch, the output would be:
  ./filefrag -B -e mntpoint/testfile
  Filesystem type is: ef53
  Filesystem cylinder groups approximately 16
  File size of mntpoint/testfile is 15360 (15 blocks of 1024 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..      11:       2049..      2060:     12:       2062: merged
     1:       12..      14:       2061..      2063:      3:       2063: merged,eof
  mntpoint/testfile: 2 extents found, perfection would be 1 extent

Changes since v1->v2
 - remove the unnecessary {} for if statement.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/filefrag.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index c1a8684..76e613f 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -315,32 +315,40 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 			return rc;
 		if (block == 0)
 			continue;
+		count++;
+
 		if (*num_extents == 0) {
 			(*num_extents)++;
 			if (force_extent) {
 				print_extent_header();
+				fm_ext.fe_logical = logical;
 				fm_ext.fe_physical = block * st->st_blksize;
+				fm_ext.fe_length = st->st_blksize;
 			}
+			last_block = block;
+			continue;
 		}
-		count++;
-		if (force_extent && last_block != 0 &&
-		    (block != last_block + 1 ||
-		     fm_ext.fe_logical + fm_ext.fe_length != logical)) {
-			print_extent_info(&fm_ext, *num_extents - 1,
-					  (last_block + 1) * st->st_blksize,
-					  blk_shift, st);
-			fm_ext.fe_length = 0;
-			(*num_extents)++;
+
+		if (force_extent) {
+			if (block != last_block + 1 ||
+			    fm_ext.fe_length + fm_ext.fe_logical != logical) {
+				print_extent_info(&fm_ext, *num_extents - 1,
+						  (last_block + 1) *
+						  st->st_blksize,
+						  blk_shift, st);
+				fm_ext.fe_logical = logical;
+				fm_ext.fe_physical = block * st->st_blksize;
+				fm_ext.fe_length = st->st_blksize;
+				(*num_extents)++;
+			} else {
+				fm_ext.fe_length += st->st_blksize;
+			}
 		} else if (last_block && (block != last_block + 1)) {
 			if (verbose)
 				printf("Discontinuity: Block %ld is at %lu (was "
 				       "%lu)\n", i, block, last_block + 1);
-			fm_ext.fe_length = 0;
 			(*num_extents)++;
 		}
-		fm_ext.fe_logical = logical;
-		fm_ext.fe_physical = block * st->st_blksize;
-		fm_ext.fe_length += st->st_blksize;
 		last_block = block;
 	}
 
-- 
1.8.3.1


--------------070806000001040908050108--
