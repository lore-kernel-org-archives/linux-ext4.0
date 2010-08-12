From: Adam Huffman <bloch@verdurin.com>
Subject: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 10:16:35 +0100
Message-ID: <20100812091635.GC2699@asrockhome.verdurin.salon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 87-194-100-54.bethere.co.uk ([87.194.100.54]:49800 "EHLO
	asrockhome.verdurin.salon" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759356Ab0HLJdR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 05:33:17 -0400
Received: from asrockhome.verdurin.salon (asrockhome.verdurin.salon [127.0.0.1])
	by asrockhome.verdurin.salon (8.14.4/8.14.4) with ESMTP id o7C9Gbme019819
	for <linux-ext4@vger.kernel.org>; Thu, 12 Aug 2010 10:16:37 +0100
Received: (from adam@localhost)
	by asrockhome.verdurin.salon (8.14.4/8.14.4/Submit) id o7C9GZa8019817
	for linux-ext4@vger.kernel.org; Thu, 12 Aug 2010 10:16:35 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hope it's okay to send "user problems" here.  

I've made a 15TB logical volume on a 21TB RAID6 iSCSI array.

When I try to make an ext4 filesystem I see the following error:

mke4fs -E stride=32 stripe-width=384 -i 65536 -j -v \
/dev/mapper/vg2md3000isata-homes2 

mke4fs 1.41.9 (22-Aug-2009)
mke4fs: invalid blocks count - /dev/mapper/vg2md3000isata-homes2

Some more details:

--- Physical volume ---
  PV Name               /dev/mpath/mpath4
  VG Name               vg2md3000isata
  PV Size               21.83 TB / not usable 32.00 MB
  Allocatable           yes 
  PE Size (KByte)       32768
  Total PE              715205
  Free PE               223685
  Allocated PE          491520
  PV UUID               psv5BF-Tkvv-p7uq-ED0k-DCPd-3es1-uNnNSg

--- Logical volume ---
  LV Name                /dev/vg2md3000isata/homes2
  VG Name                vg2md3000isata
  LV UUID                qieiLw-F0he-DlDD-bZeA-v2Ok-DmE5-oS3uy2
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                15.00 TB
  Current LE             491520
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:11

--- Volume group ---
  VG Name               vg2md3000isata
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               21.83 TB
  PE Size               32.00 MB
  Total PE              715205
  Alloc PE / Size       491520 / 15.00 TB
  Free  PE / Size       223685 / 6.83 TB
  VG UUID               vLwJLm-z1gj-RZrM-GjXX-hmLo-cf6B-8EGMyR

When i searched briefly yesterday, some documentation stated that the
filesystem limit was now 16TB, and some that the limit was much higher.

The system is running Centos 5.5, e4fsprogs-1.41.9-3.el5.


Adam
