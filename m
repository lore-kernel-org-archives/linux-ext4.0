From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 out of order when use cfq scheduler
Date: Wed, 16 Mar 2016 02:30:13 +0000
Message-ID: <4ec8c36a910942be8d6d4745385f3cce@SGPMBX1004.APAC.bosch.com>
References: <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz> <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz> <20160314143635.GM29218@thunk.org>
 <20160315104634.GG17942@quack.suse.cz> <20160315144633.GA12352@quack.suse.cz>
 <20160315200951.GA1445@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:15728 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbcCPCaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2016 22:30:18 -0400
In-Reply-To: <20160315200951.GA1445@quack.suse.cz>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> >
> > OK, I have something - Huang, can you check whether the attached
> > patches also fix your data exposure issues please? The first patch is
> > the original fix, patch two is a cleanup, patches 3 and 4 implement
> > the speedup suggested by Ted. Patches are only lightly tested so far.
> > I'll run more comprehensive tests later and in particular I want to
> > check whether the additional complexity actually brings us some
> > advantage at least for workloads which redirty pages in addition to
> > writing some new ones using delayed allocation.
> 
> OK, there was a bug in patch 3. Attached is a new version of patches 3 and 4.
> 


Hi Kara,
Patches are applied on my kernel. Basically it is working. 
Power loss test is running now. Need some days to give you test result.
At same time, Some conflicts need your confirm:

Target Kernel 3.10.63.

Patch 0004 conflicts:
----------------------------------
- Don't have function:   *mpage_map_one_extent*
So , please review this segment code at  patch 0004-ext4-Do-not-ask-jbd2-to-write-data-for-delalloc-buff.patch

@@ -1697,7 +1700,8 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	 * So use reserved blocks to allocate metadata if possible.
 	 */
 	get_blocks_flags = EXT4_GET_BLOCKS_CREATE |
-			   EXT4_GET_BLOCKS_METADATA_NOFAIL;
+			   EXT4_GET_BLOCKS_METADATA_NOFAIL |
+			   EXT4_GET_BLOCKS_IO_SUBMIT;
 	if (ext4_should_dioread_nolock(mpd->inode))
 		get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
 	if (mpd->b_state & (1 << BH_Delay))


- Don't have function *__ext4_block_zero_page_range*, so ignore the modification under this function.


Patch 0001 conflicts:
----------------------------------
- Don't have macro EXT4_GET_BLOCKS_ZERO is not available on kernel 3.10.63, so the patch is like this please help to review:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e48bd5a..03017a9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -751,6 +751,19 @@ has_zeroout:
 		int ret = check_block_validity(inode, map);
 		if (ret != 0)
 			return ret;
+
+		/*
+		 * Inodes with freshly allocated blocks where contents will be
+		 * visible after transaction commit must be on transaction's
+		 * ordered data list.
+		 */
+		if (map->m_flags & EXT4_MAP_NEW &&
+		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
+		    ext4_should_order_data(inode)) {
+			ret = ext4_jbd2_file_inode(handle, inode);
+			if (ret)
+				return ret;
+		}
 	}
 	return retval;
 }

