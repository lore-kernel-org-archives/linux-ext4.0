From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fix file system corruption [ was Re: mballoc errors ]
Date: Tue, 1 Apr 2008 02:20:30 +0530
Message-ID: <20080331205030.GB30646@skywalker>
References: <47EAC302.5040109@redhat.com> <47ECFAC7.3050404@bull.net> <20080331065802.GA19456@skywalker> <47F0FBFE.7060404@bull.net> <20080331201819.GA30646@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:42204 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYCaUul (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2008 16:50:41 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2VKnu6v008124
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 07:49:56 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2VKodfj2769054
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 07:50:39 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2VKodfv002967
	for <linux-ext4@vger.kernel.org>; Tue, 1 Apr 2008 06:50:39 +1000
Content-Disposition: inline
In-Reply-To: <20080331201819.GA30646@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 01, 2008 at 01:48:19AM +0530, Aneesh Kumar K.V wrote:
> On Mon, Mar 31, 2008 at 04:58:06PM +0200, Valerie Clement wrote:
> 
> I actually added fallocate to fsstress and created the file filesystem
> as you suggested. I am able to reproduce the problem once. Currently
> doing a code audit. Will let you know if i make any progress.
> 

I found one case where it could fail. We are returning total extent size
in case of converting from uninitialized extent to initialized one. 
Now if we have the below layout

[p --------x--------]

where p is the start block and x is the location where we intent to
write. If converting the above uninit extent resulted in 

[p zeroed-out][uninit].

We should not be returning the size of
zeroed-out-extent. That is because in ext4_ext_get_blocks we cache
the extent information as below

out_new:
		....
/* Cache only when it is _not_ an uninitialized extent */
if (create != EXT4_CREATE_UNINITIALIZED_EXT)
	ext4_ext_put_in_cache(inode, iblock, allocated, newblock,
						EXT4_EXT_CACHE_EXTENT);
out:


That would mean we are caching an extent starting from newblock of
size allocated where allocated would be the size of zeroout extent,
which is actually wrong.

I am yet to test the patch. If you have time can you test the below
change

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 964d2c1..91f8f72 100644
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
@@ -2309,11 +2310,13 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				ex->ee_len   = orig_ex.ee_len;
 				ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 				ext4_ext_dirty(handle, inode, path + depth);
-				return le16_to_cpu(ex->ee_len);
+				/* zeroed the full extent */
+				return allocated;
 
 			} else if (err)
 				goto fix_extent_len;
 
+			/* zeroed the second half */
 			return allocated;
 		}
 		ex3 = &newex;
@@ -2331,7 +2334,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
-			return le16_to_cpu(ex->ee_len);
+			/* zeroed the full extent */
+			return allocated;
 
 		} else if (err)
 			goto fix_extent_len;
@@ -2379,7 +2383,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 			ext4_ext_dirty(handle, inode, path + depth);
-			return le16_to_cpu(ex->ee_len);
+			/* zero out the first half */
+			return allocated;
 		}
 	}
 	/*
@@ -2446,7 +2451,8 @@ insert:
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
 		ext4_ext_dirty(handle, inode, path + depth);
-		return le16_to_cpu(ex->ee_len);
+		/* zero out the first half */
+		return allocated;
 	} else if (err)
 		goto fix_extent_len;
 out:
