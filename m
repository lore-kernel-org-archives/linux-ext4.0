From: Daniel Pocock <daniel@pocock.com.au>
Subject: ext4, barrier, md/RAID1 and write cache
Date: Mon, 07 May 2012 10:47:26 +0000
Message-ID: <4FA7A83E.6010801@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:54725 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2EGKrn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2012 06:47:43 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 506971586E
	for <linux-ext4@vger.kernel.org>; Mon,  7 May 2012 11:47:42 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id iWlh2TiRusFs for <linux-ext4@vger.kernel.org>;
	Mon,  7 May 2012 11:47:27 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



I've been having some NFS performance issues, and have been
experimenting with the server filesystem (ext4) to see if that is a factor.

The setup is like this:

(Debian 6, kernel 2.6.39)
2x SATA drive (NCQ, 32MB cache, no hardware RAID)
md RAID1
LVM
ext4

a) If I use data=ordered,barrier=1 and `hdparm -W 1' on the drive, I
observe write performance over NFS of 1MB/sec (unpacking a big source
tarball)

b) If I use data=writeback,barrier=0 and `hdparm -W 1' on the drive, I
observe write performance over NFS of 10MB/sec

c) If I just use the async option on NFS, I observe up to 30MB/sec

I believe (b) and (c) are not considered safe against filesystem
corruption, so I can't use them in practice.

Can anyone suggest where I should direct my efforts to lift performance?
 E.g.

- does SCSI work better with barriers, will buying SCSI drives just
solve the problem using config (a)?

- should I do away with md RAID and consider btrfs which does RAID1
within the filesystem itself?

- or must I just use option (b) but make it safer with battery-backed
write cache?

- or is there any md or lvm issue that can be tuned or fixed by
upgrading the kernel?
