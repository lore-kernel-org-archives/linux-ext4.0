From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 7 Aug 2009 22:38:00 GMT
Message-ID: <200908072238.n77Mc0b4028521@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41111 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbZHGWiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 18:38:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n77Mc0WG028522
	for <linux-ext4@vger.kernel.org>; Fri, 7 Aug 2009 22:38:00 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D13930





--- Comment #3 from C=C3=A9dric M <zelogik+bugzilla@gmail.com>  2009-08=
-07 22:37:59 ---
I have make some try on a 242MB file:

du -h file
242M

And after an:
=46ilesystem type is: ef53
=46ile size of ****** is 253480960 (61885 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0 215814144            2048=20
   1    2048 215820288 215816191   2048=20
   2    4096 215824384 215822335   2048=20
   3    6144 215828480 215826431   2048=20
   4    8192 215832576 215830527   2048=20
   5   10240 215836672 215834623   2048=20
   6   12288 215840768 215838719   2048=20
   7   14336 215844864 215842815   2048=20
   8   16384 215848960 215846911   2048=20
   9   18432 215853056 215851007  26624=20
  10   45056 215881728 215879679   2048=20
  11   47104 215885824 215883775   2048=20
  12   49152 215891968 215887871   2048=20
  13   51200 215896064 215894015   2048=20
  14   53248 215900160 215898111   2048=20
  15   55296 215904256 215902207   2048=20
  16   57344 215908352 215906303   2048=20
  17   59392 215912448 215910399   2048=20
  18   61440 215918592 215914495    445 eof


So why so much extend ?

(ie: ALL files have been write one to one on the whole disk (like a "cp=
 -R
/cifs /ext4) (not torrent/crappy_speed_download_tools/etc ... things))




With a full dir: (for / du -h / filefrag / sed )
180M   =20
: 12 extents found
181M   =20
: 20 extents found
281M   =20
: 22 extents found
275M   =20
: 22 extents found
275M   =20
: 22 extents found
181M   =20
: 20 extents found
281M   =20
: 22 extents found
281M   =20
: 21 extents found
277M   =20
: 21 extents found
280M   =20
: 21 extents found
180M   =20
: 21 extents found
285M   =20
: 13 extents found
180M   =20
: 6 extents found

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
