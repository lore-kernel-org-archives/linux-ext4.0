From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [Bug 32182] New: EXT4-fs error: bad header/extent
Date: Fri, 1 Apr 2011 22:07:32 +0800
Message-ID: <AANLkTimrBs1kdNmS7d2DoTwa=wRHRu5DZKhRdk7DpcA9@mail.gmail.com>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56642 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab1DAOHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 10:07:33 -0400
Received: by gwaa18 with SMTP id a18so1409303gwa.19
        for <linux-ext4@vger.kernel.org>; Fri, 01 Apr 2011 07:07:32 -0700 (PDT)
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Could the bug be reproduced?
If so,  how to?

On Wed, Mar 30, 2011 at 12:47 AM,  <bugzilla-daemon@bugzilla.kernel.org=
> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D32182
>
> =A0 =A0 =A0 =A0 =A0 Summary: EXT4-fs error: bad header/extent
> =A0 =A0 =A0 =A0 =A0 Product: File System
> =A0 =A0 =A0 =A0 =A0 Version: 2.5
> =A0 =A0Kernel Version: 2.6.38.1
> =A0 =A0 =A0 =A0 =A0Platform: All
> =A0 =A0 =A0 =A0OS/Version: Linux
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Tree: Mainline
> =A0 =A0 =A0 =A0 =A0 =A0Status: NEW
> =A0 =A0 =A0 =A0 =A0Severity: high
> =A0 =A0 =A0 =A0 =A0Priority: P1
> =A0 =A0 =A0 =A0 Component: ext4
> =A0 =A0 =A0 =A0AssignedTo: fs_ext4@kernel-bugs.osdl.org
> =A0 =A0 =A0 =A0ReportedBy: ramses.rommel@gmail.com
> =A0 =A0 =A0 =A0Regression: No
>
>
> I started noticing ext4-fs errors in my dmesg output, they look like =
this:
>
> EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760218=
: comm
> dropbox: bad header/extent: invalid magic - magic 0, entries 0, max 0=
(0), depth
> 0(0)
> EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760208=
: comm
> dropbox: bad header/extent: invalid magic - magic 0, entries 0, max 0=
(0), depth
> 0(0)
> EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760218=
: comm
> thunderbird-bin: bad header/extent: invalid magic - magic 0, entries =
0, max
> 0(0), depth 0(0)
> EXT4-fs error (device sda2): ext4_ext_check_inode:428: inode #3760208=
: comm
> thunderbird-bin: bad header/extent: invalid magic - magic 0, entries =
0, max
> 0(0), depth 0(0)
>
> I fsck'ed the partition which showed nothing but the regular output b=
ut said
> the file system was modified, after a reboot the same errors returned=
 though.
> I'm using e2fsprogs 1.41.14 and linux 2.6.38.1 and after a downgrade =
to linux
> 2.6.37.5 the errors kept reappearing (I'll test 2.6.38.2 soon but I d=
idn't find
> commit messages that seemed relevant).
>
> I ran debugfs on one of the inodes:
>
> % debugfs -R 'stat <3760208>' /dev/disk/by-label/home
> debugfs 1.41.14 (22-Dec-2010)
> Inode: 3760208 =A0 Type: regular =A0 =A0Mode: =A00644 =A0 Flags: 0x80=
000
> Generation: 231468018 =A0 =A0Version: 0x00000001
> User: =A01000 =A0 Group: =A0 100 =A0 Size: 42
> File ACL: 0 =A0 =A0Directory ACL: 0
> Links: 1 =A0 Blockcount: 0
> Fragment: =A0Address: 0 =A0 =A0Number: 0 =A0 =A0Size: 0
> ctime: 0x4b2a09ff -- Thu Dec 17 11:37:51 2009
> atime: 0x4d909367 -- Mon Mar 28 15:55:51 2011
> mtime: 0x490976f8 -- Thu Oct 30 09:57:28 2008
> EXTENTS:
>
> I'm not sure what extra info to give you, but I'd be glad to provide =
stuff you
> need to reproduce/fix this.
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Dem=
ail
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
