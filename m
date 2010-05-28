From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Huge flex_bg count kills mke2fs
Date: Fri, 28 May 2010 13:25:45 -0600
Message-ID: <FEF991E9-883A-444F-B3C4-5E0051665B20@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Zhiqi Tao <zhiqi.tao@oracle.com>
To: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:64463 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0E1T0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 15:26:06 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o4SJQ2S8003191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 19:26:04 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id o4SICeK2016059
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 19:26:01 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We're trying to put all of the static ext4 metadata at the beginning of the disk to see whether this gives us a performance improvement (avoid seeking during e2fsck, avoid free space fragmentation).  This is on a filesystem somewhat smaller than 16TB, and the flex_bg count 131072 would seem large enough to put all of groups into a single flex group.

However, running the below command spins forever, apparently trying to allocate the static metadata:

mke2fs -j -b 4096 -G 131072 -J size=1024 -i 65536 \
    -O flex_bg,uninit_bg,extents -I 256 -F /dev/vgost0/lvost0 4294965248

Looking at the mke2fs/libext2fs code it appears that it will try to allocate a contiguous space for the each bitmap, so a flex_bg size of 32768 would be the maximum the number of blocks in a group.  Unfortunately, with the superblock in the way, there are only 32767 free blocks in groups 0 and 1, yet we can't use this size since flex_bg size of 32767 is not allowed (must be a power of two).  It would also seem possible to allocate 131071 blocks worth of bitmaps across groups 5-8 and 9-12 (each of which have a single superblock), and then go back and stuff inode tables into groups 0-4 but I'm not yet sure why it isn't doing that.

Any ideas before I have to dig into the libext2fs/flex_bg allocator?

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

