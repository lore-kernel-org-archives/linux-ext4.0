From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 22:08:39 GMT
Message-ID: <200910142208.n9EM8d8w030871@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58965 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbZJNWJQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 18:09:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9EM8dCE030872
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 22:08:39 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #49 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-14 22:08:38 ---
i get same issue on 2.6.32-rc4. I worked on uvc (webcam) module so, installed
same module over and over. At some time i accidentally pluged webcam off during
it was used by cheese. As result i get kernel oops ... restart didn't worked so
i reseted it. Blame me i forgot o save oops... i have now only dmesg after
restart, fsck and dd-image of the root before dmesg.

[    5.573939] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[    5.573942] EXT4-fs (dm-0): write access will be enabled during recovery
[    5.628089] EXT4-fs (dm-0): orphan cleanup on readonly fs
[    5.640860] EXT4-fs warning (device dm-0): ext4_orphan_get: bad orphan inode
133701!  e2fsck was run?
[    5.640863] ext4_test_bit(bit=2628, block=524304) = -1
[    5.640864] inode=ffff880138764840
[    5.640865] is_bad_inode(inode)=0
[    5.640866] NEXT_ORPHAN(inode)=1255554482
[    5.640867] max_ino=1220608
[    5.640867] i_nlink=0
[    5.640895] EXT4-fs (dm-0): recovery complete
[    5.807823] EXT4-fs (dm-0): mounted filesystem with ordered data mode
....
[   10.673483] EXT4-fs error (device dm-0): ext4_lookup: deleted inode
referenced: 394941
[   10.673626] EXT4-fs error (device dm-0): ext4_lookup: deleted inode
referenced: 394941
[   10.673699] EXT4-fs error (device dm-0): ext4_lookup: deleted inode
referenced: 394941
...

fsck has lots of:
File
/lib/modules/2.6.32-rc4-00094-g80f5069-dirty/kernel/arch/x86/kernel/cpu/cpu_debug.ko
(inode #393904, mod time Wed Oct 14 22:47:35 2009) 
  has 57 multiply-claimed block(s), shared with 2 file(s):
    ... (inode #394934, mod time Wed Oct 14 21:53:34 2009)
    /lib/modules/2.6.32-rc4-00094-g80f5069-dirty/modules.symbols.bin (inode
#394931, mod time Wed Oct 14 21:53:33 2009)
Clone multiply-claimed blocks? yes

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
