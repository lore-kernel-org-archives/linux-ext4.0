From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Mon, 29 Nov 2010 21:55:04 GMT
Message-ID: <201011292155.oATLt4vX027018@demeter2.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:34179 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0K2VzF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 16:55:05 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oATLt4D0027019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 21:55:04 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772


Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca




--- Comment #14 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca>  2010-11-29 21:55:03 ---
(In reply to comment #10)
> Well, one question is how did the stale data get put there in the first place? 
> The entire superblock is zero'ed out by mke2fs.

The s_mount_options field has the unfortunate distinction of being the first
field beyond 0x200 in the superblock (i.e. second sector of 1kB superblock
area).  This means it could have been corrupted at some time in the past by an
incomplete write or similar, and no e2fsck will have checked/fixed this.

Looking at the 'dd' output, it is clear that both the area before and after the
512-bytes of the original superblock were clobbered by 0xffff data at one time
or another, and I suspect the superblock was rewritten from a backup copy but
only the first sector was written to disk.

(In reply to comment #12)
> I there is a way to fix it on the user space side?

Fairly simple, for this specific case.  It should overwrite the 512-byte area
beyond the superblock with zeroes:

dd if=/dev/zero of=/dev/dsk/by-label/MyBook bs=512 count=1 seek=3 skip=3

That said, I don't know how common or unusual this kind of garbage data is in
this area of the filesystem.  It might make sense that errors parsing of the
s_mount_options field is not taken as a fatal error at mount time, since this
can make a system unbootable, and no e2fsck will fix it.

For e2fsck, it probably makes sense to limit the data in s_mount_opts to
printable ASCII characters, and otherwise zero out any remaining data.  I'm not
sure what to do for the rest of the superblock, however.

Should e2fsck zero out that data if s_mount_opts is found to be bad?  Should we
wait until every field is defined, and then fix them on a case-by-case basis? 
The former is preferable because otherwise it means the kernel can never start
using any of these fields without e2fsck having verified the content first, but
it has the drawback that any corruption just to s_mount_opts may wipe out the
rest of the superblock.

In that regard, it would have been preferable to locate the "s_first_error" and
"s_last_error" fields near the end of the 1kB superblock range, instead of
quickly consuming the rest of the space in the first sector (which we know will
be written atomically), which is why it would be nice if such changes were
discussed and reviewed on the mailing list rather than being presented as a
fait-accompli in some kernel update and/or e2fsprogs release.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
