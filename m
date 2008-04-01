From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix file system corruption [ was Re: mballoc errors ]
Date: Tue, 1 Apr 2008 14:31:49 +0530
Message-ID: <20080401090149.GB9121@skywalker>
References: <47EAC302.5040109@redhat.com> <47ECFAC7.3050404@bull.net> <20080331065802.GA19456@skywalker> <47F0FBFE.7060404@bull.net> <20080331201819.GA30646@skywalker> <20080331205030.GB30646@skywalker> <47F1F49A.7020102@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57169 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbYDAJCA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2008 05:02:00 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m3191nhG019745
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 14:31:49 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3191ntw1142888
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 14:31:49 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m3191nh8028153
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 09:01:49 GMT
Content-Disposition: inline
In-Reply-To: <47F1F49A.7020102@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 01, 2008 at 10:38:50AM +0200, Valerie Clement wrote:
>
> Hi Aneesh,
> I tested your patch but unfortunately I still reproduced the problem with it:
> EXT4-fs error (device sdc1): ext4_valid_block_bitmap: Invalid block 
> bitmap - block_group = 6233, block = 51060737
>

Below is the patch i am testing. It is running fine for me here. I am
testing the patch with a modified fsstress that use fallocate.

Regarding the test case that you have i am not yet sure what is causing
the file system corruption. It cannot be ext4_ext_zeroout or 
ext4_ext_convert_to_initialized because they are used only when we are
writing to falloc area and you are not preallocating anything in your
test. Did you make sure you are not using delalloc ? All my tests are
run with stable branch.

You would also need the single line change you found in ext4_ext_zeroout
It is already a part of patch queue.

commit c664eac338ae9c6139ffec72fca84b222bf142b2
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Apr 1 13:23:21 2008 +0530

    ext4: Cache the correct extent length for uninit extent.
    
    When we convert uninitialized extent to initialized extent
    we need to make sure we return the number of blocks in the
    extent from the file system block corresponding to logical
    file block. Other wise we cache wrong extent details and this
    results in file system corruption.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 964d2c1..30f0f99 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2264,7 +2264,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
-		return le16_to_cpu(ex->ee_len);
+		/* zeroed the full extent */
+		return allocated;
 	}
 
 	/* ex1: ee_block to iblock - 1 : uninitialized */
@@ -2309,11 +2310,44 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				ex->ee_len   = orig_ex.ee_len;
 				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
-				return le16_to_cpu(ex->ee_len);
+				/* zeroed the full extent */
+				return allocated;
 
 			} else if (err)
 				goto fix_extent_len;
 
+			/* We need to zero out the second half because
+			 * fallocate request can update file size and
+			 * converting the second half to initialized extent
+			 * implies that we can leak some junk data to user
+			 * space
+			 */
+			err =  ext4_ext_zeroout(inode, ex3);
+			if (err) {
+				/*
+				 * We should actually mark the
+				 * second half as uninit and return error
+				 * Insert would have changed the extent
+				 */
+				depth = ext_depth(inode);
+				ext4_ext_drop_refs(path);
+				path = ext4_ext_find_extent(inode,
+								iblock, path);
+				if (IS_ERR(path)) {
+					err = PTR_ERR(path);
+					return err;
+				}
+				ex = path[depth].p_ext;
+				err = ext4_ext_get_access(handle, inode,
+								path + depth);
+				if (err)
+					return err;
+				ext4_ext_mark_uninitialized(ex);
+				ext4_ext_dirty(handle, inode, path + depth);
+				return err;
+			}
+
+			/* zeroed the second half */
 			return allocated;
 		}
 		ex3 = &newex;
@@ -2331,7 +2365,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
-			return le16_to_cpu(ex->ee_len);
+			/* zeroed the full extent */
+			return allocated;
 
 		} else if (err)
 			goto fix_extent_len;
@@ -2379,7 +2414,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
-			return le16_to_cpu(ex->ee_len);
+			/* zero out the first half */
+			return allocated;
 		}
 	}
 	/*
@@ -2446,7 +2482,8 @@ insert:
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
-		return le16_to_cpu(ex->ee_len);
+		/* zero out the first half */
+		return allocated;
 	} else if (err)
 		goto fix_extent_len;
 out:

