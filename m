From: Eric Sandeen <sandeen@redhat.com>
Subject: large resize busted in master
Date: Thu, 23 Dec 2010 09:41:10 -0600
Message-ID: <4D136D96.7060600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0LWPlL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Dec 2010 10:41:11 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBNFfBt5027528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Dec 2010 10:41:11 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBNFfASN030724
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Dec 2010 10:41:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

just FYI; I don't know when I'll have time to look into it, but
in case anyone else wants to :)

# rm -f /mnt/test2/16tfile
# touch /mnt/test2/16tfile
# truncate --size 16t /mnt/test2/16tfile
# mkfs.ext4 -F -E lazy_itable_init=1 /mnt/test2/16tfile
# resize/resize2fs /mnt/test2/16tfile 4294967290
resize2fs 1.41.14 (22-Dec-2010)
Resizing the filesystem on /mnt/test2/16tfile to 4294967290 (4k) blocks.
Illegal block number passed to ext2fs_unmark_block_bitmap #4294967295 for block bitmap for /mnt/test2/16tfile
resize/resize2fs: Invalid argument while trying to resize /mnt/test2/16tfile
Please run 'e2fsck -fy /mnt/test2/16tfile' to fix the filesystem
after the aborted resize operation.


-Eric
