From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93031] root becomes read-only at boot due to
 journal_async_commit in /etc/fstab
Date: Fri, 23 Oct 2015 12:27:00 +0000
Message-ID: <bug-93031-13602-TcJ14l4YtD@https.bugzilla.kernel.org/>
References: <bug-93031-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51351 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbbJWM1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Oct 2015 08:27:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BDA0C20972
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2015 12:27:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8A7F620968
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2015 12:27:00 +0000 (UTC)
In-Reply-To: <bug-93031-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93031

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
It works if you don't have journal_async_commit in /etc/fstab and you also use
journal_async_commit in rootflags:

% kvm-xfstests -o rootflags=journal_async_commit shell
Networking disabled.

(process:13728): GLib-WARNING **:
/build/glib2.0-l3js1a/glib2.0-2.46.1/./glib/gmem.c:482: custom memory
allocation vtable not supported
[    2.405408] systemd-fsck[1392]: /dev/vda: clean, 10240/65536 files,
66092/262144 blocks
[    2.720772] systemd-fsck[2455]: /dev/vdg: recovering journal
[    2.732840] systemd-fsck[2455]: /dev/vdg: clean, 86/327680 files,
58658/1310720 blocks

Debian GNU/Linux 8 kvm-xfstests ttyS0

kvm-xfstests login: root (automatic login)

Linux kvm-xfstests 4.3.0-rc2ext4-00025-g1a70ea8 #223 SMP Mon Oct 19 00:01:49
EDT 2015 i686

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
root@kvm-xfstests:~# grep root /etc/fstab
/dev/rootfs    /    ext4    noatime 0 1
root@kvm-xfstests:~# grep root /proc/mounts
/dev/root / ext4 rw,noatime,journal_checksum,journal_async_commit,data=ordered
0 0
root@kvm-xfstests:~# cat /proc/cmdline
quiet loglevel=0 root=/dev/vda console=ttyS0,115200 cmd=maint
fstesttz=America/New_York fstesttyp=ext4 fstestapi=1.2
rootflags=journal_async_commit


The changes that were made between 3.13 and 3.18 were intentional and made for
good reasons.   Changing journalling modes while the file system is mounted is
dangerous.  In the specific case of changing a read-only to read-write mode it
could be made safe, but it's not a priority, because (a) there _is_ a
workaround that works, (b) journal_async_commit is not something that to be
honest, is not safe unless you are using a pre-release 1.43 version of
e2fsprogs, and I'm not super eager to encourage more people to use it unless
they really, really know what they are doing.   One way you can prove that you
know what you are doing is to submit a patch.  Using terms like "pedantic
idiots" isn't calculated to encourage people to go out of their way to help you
or to think that you indeed know what you are doing.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
