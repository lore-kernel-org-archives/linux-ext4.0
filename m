From: Paolo Bonzini <pbonzini@redhat.com>
Subject: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
Date: Thu, 09 Aug 2012 12:00:09 +0200
Message-ID: <50238A29.3060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu,
	"Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
	<linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab2HIKAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2012 06:00:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here is how to reproduce it.  It happens during fstrim.  I found other
occurrences of the error in the mailing list, but they were not related
to trim so they may be something different.

modprobe scsi_debug dev_size_mb=256 lbpws=1
dd if=/dev/zero of=/dev/sdb bs=1M      
fdisk /dev/sdb
 >> create a new partition accepting all defaults
fdisk -lu /dev/sdb|tail -1
 >> should show: /dev/sdb1     57      524285      262114+  83  Linux

mkfs.ext4 /dev/sdb1
mkdir test
mount /dev/sdb1 test
fstrim ./test

Here is the output in dmesg:

[140934.644166] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[140941.562060] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 16, 8160 clusters in bitmap, 4064 in gd
[140941.603066] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 25, 8192 clusters in bitmap, 7934 in gd
[140941.613060] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 27, 8192 clusters in bitmap, 7934 in gd
[140941.634074] EXT4-fs error (device sdb1): ext4_mb_generate_buddy:741: group 31, 8192 clusters in bitmap, 8159 in gd

Hope this helps,

Paolo
