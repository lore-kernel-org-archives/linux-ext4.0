From: "Yan Zheng" <yanzheng@21cn.com>
Subject: [BUG?] "ext4_ext_put_in_cache" uses __u32 to receive physical block number.
Date: Fri, 27 Jul 2007 13:16:14 +0800
Message-ID: <3d0408630707262216i3f8e1c35ub49be9c210f963d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, all

I think I found a bug in ext4/extents.c, "ext4_ext_put_in_cache" uses
"__u32" to receive physical block number.  "ext4_ext_put_in_cache" is
used in "ext4_ext_get_blocks", it sets ext4 inode's extent cache
according most recently tree lookup (higher 16 bits of saved physical
block number are always zero). when serving a mapping request,
"ext4_ext_get_blocks" first check whether the logical block is in
inode's extent cache. if the logical block is in the cache and the
cached region isn't a gap, "ext4_ext_get_blocks" gets physical block
number by using cached region's physical block number and offset in
the cached region.  as described above, "ext4_ext_get_blocks" may
return wrong result when there are physical block numbers bigger than
0xffffffff.

Regards

YZ
