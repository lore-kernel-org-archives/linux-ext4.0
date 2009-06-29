From: Andreas Dilger <adilger@sun.com>
Subject: ext4_ext_calc_credits_for_single_extent() bug?
Date: Tue, 30 Jun 2009 00:41:33 +0200
Message-ID: <20090629224133.GF19362@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63976 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZF2Wlx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 18:41:53 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5TMfpMj014089
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 15:41:52 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KM000M00UL1N100@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 29 Jun 2009 15:41:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was looking at the function ext4_ext_calc_credits_for_insert(), because
it appeared similar to a function we were using in Lustre and I wanted to
remove redundant code from our patches.  On closer inspection, however,
that function is doing something strange that wasn't in our original code.

int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
                                                struct ext4_ext_path *path)
{
        if (path) {
                int depth = ext_depth(inode);
                int ret = 0;

                /* probably there is space in leaf? */
                if (le16_to_cpu(path[depth].p_hdr->eh_entries)
                                < le16_to_cpu(path[depth].p_hdr->eh_max)) {

                        /*
                         *  There are some space in the leaf tree, no
                         *  need to account for leaf block credit
                         *
                         *  bitmaps and block group descriptor blocks
                         *  and other metadat blocks still need to be
                         *  accounted.
                         */
                        /* 1 bitmap, 1 block group descriptor */
                        ret = 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
                }
        }

        return ext4_chunk_trans_blocks(inode, nrblocks);
}

It computes "ret" but doesn't actually use it, and then
ext4_chunk_trans_blocks() does nothing but call ext4_meta_trans_blocks(),
which is doing the bulk of the calculation.

It looks like this was committed by Mingming in "ext4: journal credits
reservation fixes for extent file writepage"
ee12b630687d510f6f4b6d4acdc4e267fd4adeda

Ideally we would use the "path" information to generate an accurate block
count for this extent.  Can we just return "ret" in this case?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

