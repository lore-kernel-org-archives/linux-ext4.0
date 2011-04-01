From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Fri, 1 Apr 2011 14:07:57 GMT
Message-ID: <201104011407.p31E7vbQ026250@demeter2.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48189 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab1DAOH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Apr 2011 10:07:58 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p31E7v0L026251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Apr 2011 14:07:57 GMT
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D32182





--- Comment #1 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org> =
 2011-04-01 14:07:56 ---
Reply-To: xiaoqiangnk@gmail.com

Could the bug be reproduced?
If so,  how to?

On Wed, Mar 30, 2011 at 12:47 AM,  <bugzilla-daemon@bugzilla.kernel.org=
> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D32182
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Summary: EXT4-fs error: bad header=
/extent
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Product: File System
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version: 2.5
> =C2=A0 =C2=A0Kernel Version: 2.6.38.1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Platform: All
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OS/Version: Linux
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Tree: Mainline
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: NEW
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Severity: high
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Priority: P1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Component: ext4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0AssignedTo: fs_ext4@kernel-bugs.osdl.org
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ReportedBy: ramses.rommel@gmail.com
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Regression: No
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
> Inode: 3760208 =C2=A0 Type: regular =C2=A0 =C2=A0Mode: =C2=A00644 =C2=
=A0 Flags: 0x80000
> Generation: 231468018 =C2=A0 =C2=A0Version: 0x00000001
> User: =C2=A01000 =C2=A0 Group: =C2=A0 100 =C2=A0 Size: 42
> File ACL: 0 =C2=A0 =C2=A0Directory ACL: 0
> Links: 1 =C2=A0 Blockcount: 0
> Fragment: =C2=A0Address: 0 =C2=A0 =C2=A0Number: 0 =C2=A0 =C2=A0Size: =
0
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
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
