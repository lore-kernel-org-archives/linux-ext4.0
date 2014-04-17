From: Contact <neitsab@ovh.fr>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc, e4defrag...)
Date: Thu, 17 Apr 2014 22:11:13 +0200
Message-ID: <53503561.1060207@ovh.fr>
References: <534F39F6.2000208@ovh.fr> <20140417152457.GE18591@thunk.org> <5350205E.3030403@ovh.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo29.mail-out.ovh.net ([178.32.228.29]:40761 "EHLO
	mo29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaDQULQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 16:11:16 -0400
In-Reply-To: <5350205E.3030403@ovh.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a little update:
Nonetheless my issues with fallocate and the bigalloc'ed fs, I tried to
dd a couple of ISOs on the key and check whether I could boot from them=
=2E
And to my great surprise... The answer was yes.

$ ls -l /run/media/neitsab/iso/_ISO/
total 4980736
drwxr-xr-x 2 neitsab users       4096 17 avril 21:38 .
drwxr-xr-x 4 neitsab users       4096 17 avril 19:36 ..
-rw------- 1 neitsab users  964689920 17 avril 21:37 gnome-3.12.iso
-rw------- 1 neitsab users 1589166080 17 avril 20:45
manjaro-gnome-0.8.9-x86_64.iso
-rw------- 1 neitsab users  993001472 17 avril 21:38
openSUSE-13.1-GNOME-Live-x86_64.iso

I can boot from the two others but not from manjaro's one, which happen=
s
to be the biggest too. A comparison of xfs_io output :

$ xfs_io -f -c "fiemap -v"
'/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso'
/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso:
 EXT: FILE-OFFSET        BLOCK-RANGE       TOTAL FLAGS
   0: [0..262143]:       3145728..3407871 262144   0x0
   1: [262144..524287]:  3407872..3670015 262144   0x0
   2: [524288..786431]:  3670016..3932159 262144   0x0
   3: [786432..1048575]: 3932160..4194303 262144   0x0
   4: [1048576..1310719]: 4194304..4456447 262144   0x0
   5: [1310720..1572863]: 4456448..4718591 262144   0x0
   6: [1572864..1835007]: 5242880..5505023 262144   0x0
   7: [1835008..2097151]: 5505024..5767167 262144   0x0
   8: [2097152..2359295]: 5767168..6029311 262144   0x0
   9: [2359296..2621439]: 6029312..6291455 262144   0x0
  10: [2621440..2883583]: 6291456..6553599 262144   0x0
  11: [2883584..3103839]: 6553600..6773855 220256   0x1

$ xfs_io -f -c "fiemap -v"
'/run/media/neitsab/iso/_ISO/openSUSE-13.1-GNOME-Live-x86_64.iso'
/run/media/neitsab/iso/_ISO/openSUSE-13.1-GNOME-Live-x86_64.iso:
 EXT: FILE-OFFSET        BLOCK-RANGE         TOTAL FLAGS
   0: [0..262143]:       8912896..9175039   262144   0x0
   1: [262144..524287]:  9175040..9437183   262144   0x0
   2: [524288..786431]:  9437184..9699327   262144   0x0
   3: [786432..1048575]: 9699328..9961471   262144   0x0
   4: [1048576..1310719]: 9961472..10223615  262144   0x0
   5: [1310720..1572863]: 10223616..10485759 262144   0x0
   6: [1572864..1835007]: 10485760..10747903 262144   0x0
   7: [1835008..1939455]: 10747904..10852351 104448   0x1

$ xfs_io -f -c "fiemap -v" '/run/media/neitsab/iso/_ISO/gnome-3.12.iso'
/run/media/neitsab/iso/_ISO/gnome-3.12.iso:
 EXT: FILE-OFFSET        BLOCK-RANGE       TOTAL FLAGS
   0: [0..262143]:       6815744..7077887 262144   0x0
   1: [262144..524287]:  7077888..7340031 262144   0x0
   2: [524288..786431]:  7340032..7602175 262144   0x0
   3: [786432..1048575]: 7602176..7864319 262144   0x0
   4: [1048576..1310719]: 7864320..8126463 262144   0x0
   5: [1310720..1572863]: 8126464..8388607 262144   0x0
   6: [1572864..1835007]: 8388608..8650751 262144   0x0
   7: [1835008..1884159]: 8650752..8699903  49152   0x1

So they're all contiguous but Manjaro. I guess that brings us back to
the randomness of block allocation as explained by Luk=C3=A1=C5=A1 and =
to an
effect of file size on the probability to be non-contiguous (which is
rather logical)!

Thanks all for your explanations,
Cheers
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
