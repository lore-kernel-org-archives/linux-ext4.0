From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [BUG?] "ext4_ext_put_in_cache" uses __u32 to receive physical
	block number.
Date: Fri, 27 Jul 2007 08:39:43 -0700
Message-ID: <1185550783.6656.4.camel@localhost.localdomain>
References: <3d0408630707262216i3f8e1c35ub49be9c210f963d8@mail.gmail.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>, akpm@osdl.org, stable@kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:38449 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXG0Pjt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jul 2007 11:39:49 -0400
In-Reply-To: <3d0408630707262216i3f8e1c35ub49be9c210f963d8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-27 at 13:16 +0800, Yan Zheng wrote:
> Hi, all
> 
> I think I found a bug in ext4/extents.c, "ext4_ext_put_in_cache" uses
> "__u32" to receive physical block number.  "ext4_ext_put_in_cache" is
> used in "ext4_ext_get_blocks", it sets ext4 inode's extent cache
> according most recently tree lookup (higher 16 bits of saved physical
> block number are always zero). when serving a mapping request,
> "ext4_ext_get_blocks" first check whether the logical block is in
> inode's extent cache. if the logical block is in the cache and the
> cached region isn't a gap, "ext4_ext_get_blocks" gets physical block
> number by using cached region's physical block number and offset in
> the cached region.  as described above, "ext4_ext_get_blocks" may
> return wrong result when there are physical block numbers bigger than
> 0xffffffff.
> 
> Regards
> 
> YZ

You are right.  Thanks for reporting this!

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.22/fs/ext4/extents.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/extents.c	2007-07-27 08:31:02.000000000 -0700
+++ linux-2.6.22/fs/ext4/extents.c	2007-07-27 08:31:48.000000000 -0700
@@ -1544,7 +1544,7 @@ int ext4_ext_walk_space(struct inode *in
 
 static void
 ext4_ext_put_in_cache(struct inode *inode, __u32 block,
-			__u32 len, __u32 start, int type)
+			__u32 len, ext4_fsblk_t start, int type)
 {
 	struct ext4_ext_cache *cex;
 	BUG_ON(len == 0);
