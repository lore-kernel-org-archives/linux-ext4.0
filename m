From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Wed, 20 May 2009 01:02:33 GMT
Message-ID: <200905200102.n4K12XlB013835@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58845 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZETBCc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 21:02:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4K12XBT013836
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 01:02:33 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #4 from Theodore Tso <tytso@mit.edu>  2009-05-20 01:02:32 ---
I've been able to replicate the problem using a 2.6.30-rc6 kernel with the ext4
patch queue applied.

It seems to be utterly repeatable, and it seems to have to do with how the
locale-gen program writes out /usr/lib/locale/locale-archive.  After you run
local-gen, an md5sum of that file gives you:

e98e9a55061c63f7ae089f7ac016eac6  /mnt/usr/lib/locale/locale-archive

but after you unmount and remount the filesystem, an md5 of that file gives
you:

5ab6d62d18431d057a514eb7dbd78428  /mnt/usr/lib/locale/locale-archive

If I manually copy the file into place, it seems to be OK.   So it must be in
how the file gets copied into place.   

Unfortunately the image doesn't have strace, but I've tried stracing locale-gen
on an (32-bit x86) Ubuntu system, and it appears that locale-gen seems to
modify the file by using a combination of mmap as well as direct writes (?!?):

28124 open("/usr/lib/locale/locale-archive", O_RDWR|O_LARGEFILE) = 3
28124 fstat64(3, {st_mode=S_IFREG|0644, st_size=1330544, ...}) = 0
28124 fcntl64(3, F_SETLKW64, {type=F_WRLCK, whence=SEEK_CUR, start=0, len=56},
0xfffb3f20) = 0
28124 stat64("/usr/lib/locale/locale-archive", {st_mode=S_IFREG|0644,
st_size=1330544, ...}) = 0
28124 read(3,
"\t\1\2\336\0\0\0\0008\0\0\0\2\0\0\0\213\3\0\0\274*\0\0\26\0\0\0L\35\0\0\10"...,
56) = 56
28124 mmap2(NULL, 103860, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0xf6d58000
28124 _llseek(3, 0, [1330544], SEEK_END) = 0
28124 write(3, "\27\20\5
\23\0\0\0T\0\0\0X\0\0\0d\0\0\0d\4\0\0\0\202\2\0p\235\2\0|"..., 962094) = 962094
28124 _llseek(3, 0, [2292638], SEEK_END) = 0
28124 write(3, "\0\0"..., 2)            = 2
28124 write(3, "\24\21\3 \6\0\0\0
\0\0\0\"\0\0\0$\0\0\0(\0\0\0,\0\0\0000\0\0\0."..., 3584) = 3584
28124 munmap(0xf6d58000, 103860)        = 0
28124 close(3)                          = 0

All I can posit is that somehow some dirty bits aren't getting set so that some
data blocks aren't getting written back to disk, so that when the filesystem is
umounted and remounted.  Using debugfs to look at the file, it looks indeed
like the blocks on disk are never getting written out.   Using debugfs "dump
/usr/lib/locale/locale-archive /tmp/foo", I'm seeing the contents of what we
see after the filesystem is unmounted and remounted.   Not at all clear why not
using a journal makes a difference, though.

I've tried running fsx on a filesystem without a journal, and it's not showing
the problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
