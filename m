From: Eric Sandeen <sandeen@redhat.com>
Subject: ext4 > 16T woes
Date: Wed, 23 May 2012 13:48:34 -0500
Message-ID: <4FBD3102.6050001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817Ab2EWSsf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 May 2012 14:48:35 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4NImZTm001582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 23 May 2012 14:48:35 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q4NImYnk016738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 May 2012 14:48:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'll try to look into this but just wanted to put it out there.

After creating a 32T fs and filling it with 1T preallocated files,
I get quite a lot of corruption; this wasn't really the test
I wanted to do, I wanted to then remove a file with mostly
high blocks, run fsstress, and test recovery :(

# uname -r
3.4.0-rc4+
# truncate --size 32t imagefile2
# mkfs.ext4 -F imagefile2
mke2fs 1.42.3 (14-May-2012)
...
# mount -o loop imagefile2 /mnt/scratch
# for I in `seq 1 32`; do fallocate -l 1t /mnt/scratch/1tfile$I; done
# umount /mnt/scratch
# time e2fsck -fn imagefile2
e2fsck 1.42.3 (14-May-2012)
<many many many lines snipped>
Free blocks count wrong for group #131072 (0, counted=32768).
Fix? no

Free blocks count wrong for group #131073 (0, counted=32768).
Fix? no

Free blocks count wrong for group #131074 (0, counted=4164).
Fix? no

Free blocks count wrong (3, counted=4294967299).
Fix? no


imagefile2: ********** WARNING: Filesystem still has errors **********

imagefile2: 43/536870912 files (0.0% non-contiguous), 8589934589/8589934592 blocks

real	27m40.133s
user	27m12.886s
sys	0m6.238s

