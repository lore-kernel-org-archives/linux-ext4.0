From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: very long fsck(weeks) for a small(500GB) ext4 partition.
Date: Sat, 19 Jan 2013 17:40:44 +0100
Message-ID: <20130119174044.53b84456@x60.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw6.ovh.net ([213.251.189.206]:37763 "HELO mail27.ha.ovh.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752014Ab3ASQra (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Jan 2013 11:47:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I hope it's the right mailing list.

I was shrinking my ext4 partition with resize2fs when the electricity
went off.
Then I launched an fsck against my partition which is
at /dev/mapper/something because it's an opened LUKS partition.
The partition is a bit less than 500GB in size because it's a 500GB hdd.

Now the problem is that it's checking the filesystem since more than
433 hours according to htop.

since I've forgetten to add -y in the fsck command I've something
mechanical that keep pressing y on the keyboard all the time.

here's what fsck says at the time of writing the email:
File ... (inode #129283, mod time Tue Sep 25 21:09:35 2012) 
  has 3 multiply-claimed block(s), shared with 1 file(s):
/home/gnutoo/networking/SDR/uhd.20121031204636/host/build/docs/doxygen/???/structuhd_1_1not__implemented__error.html 
(inode #14946569, mod time Tue Sep 25 21:09:35 2012)
Clone multiply-claimed blocks<y>? yes

1) Can I stop the fsck and continue it later?
2) I've no idea how much inodes there are in the filesystem but I fear
that it it's only at the beginning of it and will last forever.
3) If I stop, and mount it, maybe I'll be able to copy the data?

e2fsprogs are at version 1.41.14-1ubuntu3.

Denis.
