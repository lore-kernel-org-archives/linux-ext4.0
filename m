From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()
Date: Wed, 28 Sep 2011 18:45:03 +0800
Message-ID: <1317206703-5604-1-git-send-email-tm@tao.ma>
References: <20110927193523.GB3309@thunk.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Xiaoyun Mao <xiaoyun.maoxy@aliyun-inc.com>,
	Yingbin Wang <yingbin.wangyb@aliyun-inc.com>,
	Jia Wan <jia.wanj@aliyun-inc.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:52227 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753772Ab1I1Kp3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 06:45:29 -0400
In-Reply-To: <20110927193523.GB3309@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 09/28/2011 03:35 AM, Ted Ts'o wrote:
> On Mon, Sep 26, 2011 at 10:28:08AM -0400, Konrad Rzeszutek Wilk wrote:
>>> > >  
>>> > >    Attached is the fix, verified in our env. 
>> > 
>> > So.. you are asking for this upstream git commit to be back-ported
>> > to 2.6.32, right?
> I'm curious --- is there a good reason why Xen users are using an
> upstream 2.6.32 kernel?  If they are using a distro kernel, fine, but
> then the distro kernel should be providing the support.  But at this
> point, 2.6.32 is so positively *ancient* that, I'm personally not
> interesting in providing free, unpaid distro support for users who
> aren't willing to either (a) pay $$$ and get a supported distro
> kernel, or (b) use a much more modern kernel.  At this point, Guest
> and Host Xen support is available in 3.0 kernels, so there's really no
> excuse, right?
actually this bug does show up in 2.6.39 and I think stable tree still
needs this fix. After some careful test, my colleague has generated
the patch. Please considering ack it so that Greg can add it into the
stable tree.

Thanks
Tao

>From 600d493b14ebd776cf8ea0e9dcdccc0d54200403 Mon Sep 17 00:00:00 2001
From: Zheng Liu <wenqing.lz@taobao.com>
Date: Wed, 28 Sep 2011 16:26:05 +0800
Subject: [PATCH] ext4: fix BUG_ON() in ext4_ext_insert_extent()

We will meet with a BUG_ON() if following script is run.

mkfs.ext4 -b 4096 /dev/sdb1 1000000
mount -t ext4 /dev/sdb1 /mnt/sdb1
fallocate -l 100M /mnt/sdb1/test
sync
for((i=0;i<170;i++))
do
        dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=`expr $i \* 2`
done
umount /mnt/sdb1
mount -t ext4 /dev/sdb1 /mnt/sdb1
dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=341
umount /mnt/sdb1
mount /dev/sdb1 /mnt/sdb1
dd if=/dev/zero of=/mnt/sdb1/test conv=notrunc bs=256k count=1 seek=340
sync

The reason is that it forgot to mark dirty when splitting two extents in
ext4_ext_convert_to_initialized(). Althrough ex has been updated in memory,
it is not dirtied both in ext4_ext_convert_to_initialized() and
ext4_ext_insert_extent(). The disk layout is corrupted. Then it will meet with
a BUG_ON() when writting at the start of that extent again.

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
index 4890d6f..cd20425 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2607,6 +2607,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex1 = ex;
 		ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
 		ext4_ext_mark_uninitialized(ex1);
+		ext4_ext_dirty(handle, inode, path + depth);
 		ex2 = &newex;
 	}
 	/*
-- 
1.7.4.1

