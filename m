From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()
Date: Fri, 28 Oct 2011 16:46:52 +0800
Message-ID: <20111028084652.GA25104@gmail.com>
References: <20110927193523.GB3309@thunk.org>
 <1317206703-5604-1-git-send-email-tm@tao.ma>
 <20111027094329.GB31921@thunk.org>
 <20111027115322.GB6379@kroah.com>
 <20111028023607.GA23772@gmail.com>
 <20111028052406.GA21306@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@aliyun-inc.com>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60332 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1J1Ips (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 04:45:48 -0400
Received: by iaby12 with SMTP id y12so3846861iab.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 01:45:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20111028052406.GA21306@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 28, 2011 at 07:24:06AM +0200, Greg KH wrote:
> On Fri, Oct 28, 2011 at 10:36:08AM +0800, Zheng Liu wrote:
> > On Thu, Oct 27, 2011 at 01:53:22PM +0200, Greg KH wrote:
> > > On Thu, Oct 27, 2011 at 05:43:29AM -0400, Ted Ts'o wrote:
> > > > On Wed, Sep 28, 2011 at 06:45:03PM +0800, Tao Ma wrote:
> > > > > actually this bug does show up in 2.6.39 and I think stable tree still
> > > > > needs this fix. After some careful test, my colleague has generated
> > > > > the patch. Please considering ack it so that Greg can add it into the
> > > > > stable tree.
> > > > 
> > > > Sorry for the delay, but yes.  This patch would be good for the stable
> > > > tree for 2.6.39 (if Greg is still accepting patches for
> > > > 2.6.39-stable).  It doesn't apply for upstream ext4 since the code has
> > > > been changed/refactored since then, but it's a good fix.
> > > 
> > > No, .39 has not been maintained for quite some time now, sorry.
> > Hi Greg,
> > 
> > Thank you for your attention. Actually this bug is between from .32 to
> > .39. Please considering to apply this patch to other stable or longterm
> > trees.
> 
> Ah, ok, that makes sense, can you provide me a patch that will apply to
> the .32 and .33-longterm kernels?
Hi Greg,

I couldn't download the .32 and .33-longterm kernels from kernel.org
because the full sources were not found on that server. Thus this patch
is generated from the .32-mainline kernel and can be applied to the .32
and .33 kernels.

regards,
Zheng

>From ff98f00676657b797c426c80804a3fde3f86ea83 Mon Sep 17 00:00:00 2001
From: Zheng Liu <wenqing.lz@taobao.com>
Date: Fri, 28 Oct 2011 15:08:30 +0800
Subject: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()
 
We will meet with a BUG_ON() if following script is run.
 
mkfs.ext4 -b 4096 /dev/sdb1 1000000
mount -t ext4 /dev/sdb1 /mnt/sdb1
fallocate -l 100M /mnt/sdb1/test
sync
for((i=0;i<170;i++))
do
        dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1
seek=`expr $i \* 2`
done
umount /mnt/sdb1
mount -t ext4 /dev/sdb1 /mnt/sdb1
dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=341
umount /mnt/sdb1
mount /dev/sdb1 /mnt/sdb1
dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=340
sync
 
The reason is that it forgot to mark dirty when splitting two extents in
ext4_ext_convert_to_initialized(). Althrough ex has been updated in
memory, it is not dirtied both in ext4_ext_convert_to_initialized() and 
ext4_ext_insert_extent(). The disk layout is corrupted. Then it will
meet with a BUG_ON() when writting at the start of that extent again.
 
Cc: stable@kernel.org #for 2.6.39
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>
Cc: Yingbin Wang <yingbin.wangyb@aliyun-inc.com>
Cc: Jia Wan <jia.wanj@aliyun-inc.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c |    1 + 
 1 files changed, 1 insertions(+), 0 deletions(-)
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 715264b..ab6fa35 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2555,6 +2555,7 @@ static int
ext4_ext_convert_to_initialized(handle_t *handle,
                ex1 = ex; 
                ex1->ee_len = cpu_to_le16(iblock - ee_block);
                ext4_ext_mark_uninitialized(ex1);
+               ext4_ext_dirty(handle, inode, path + depth);
                ex2 = &newex;
        }
        /*
-- 
1.7.4.1

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
