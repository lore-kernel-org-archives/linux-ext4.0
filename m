From: Eric Sandeen <sandeen@redhat.com>
Subject: mkfs.ext4 vs. e2fsck discard oddities
Date: Tue, 28 Feb 2012 11:34:24 -0600
Message-ID: <4F4D1020.5060204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	=?windows-1252?Q?Luk=E1?= =?windows-1252?Q?=9A_Czerner?=
	<lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2B1Re1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Feb 2012 12:34:27 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1SHYQtS007992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 28 Feb 2012 12:34:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been testing Lukas' last 2 patches for e2fsck discard, and noticed something a little odd.

If I make a 512M file, loopback mount it, and mkfs.ext4 it with discard, it uses about 17M at that point.
If I then run fsstress on it with a known seed, then run e2fsck -E discard on it, it uses about 52M.

If I repeat the above test telling mkfs.ext4 NOT to discard, I'm left with about 94M after the discarding e2fsck.

So it seems that perhaps e2fsck is not discarding everything that it could; after a discarding fsck, we should be left with the same (minimal) nr. of blocks "in use" no?

I guess that's better than discarding _more_ than it should though.  ;)

(I suppose it is possible that this is the underlying filesytem being selective about which discards it accepts, but it behaves the same way on ext4 and xfs backing filesystems)

-Eric

FWIW, sequence of events here, tested with and without "-K" on mkfs.ext4:

dd if=/dev/zero of=fsfile bs=1M count=512
losetup /dev/loop0 fsfile
mkfs.ext4 -F /dev/loop0&>/dev/null
mount /dev/loop0 mnt/
/root/git/xfstests/ltp/fsstress -s 1 -d mnt/ -n 2000 -p 4
umount mnt/
e2fsck/e2fsck.static -fy -E discard /dev/loop0> fsck1.out || exit
du -hc fsfile
losetup -d /dev/loop0

