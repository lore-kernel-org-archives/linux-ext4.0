From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93031] root becomes read-only at boot due to
 journal_async_commit in /etc/fstab
Date: Tue, 10 Feb 2015 16:53:19 +0000
Message-ID: <bug-93031-13602-JUL5GG9ztn@https.bugzilla.kernel.org/>
References: <bug-93031-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41349 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbbBJQxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Feb 2015 11:53:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EE33220166
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 16:53:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8F95F20172
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 16:53:19 +0000 (UTC)
In-Reply-To: <bug-93031-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D93031

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen <sandeen@redhat.com> ---
If you really want that option (which, btw, had been simply ignored on =
a
remount, prior to this change) you can add it to the rootflags=3D kerne=
l
parameter.

But also:

http://marc.info/?l=3Dlinux-ext4&m=3D142358693108213&w=3D2

[PATCH 2/2, RFC] ext4: ignore journal checksum on remount; don't fail

As of v3.18, ext4 started rejecting a remount which changes the
journal_checksum option.

Prior to that, it was simply ignored; the problem here is that
if someone has this in their fstab for the root fs, now the box
fails to boot properly, because remount of root with the new options
will fail, and the box proceeds with a readonly root.

I think it is a little nicer behavior to accept the option, but
warn that it's being ignored, rather than failing the mount,
but that might be a subjective matter...

Reported-by: C=C3=83=C2=B3nr=C3=83=C2=A4d <conradsand.arma@gmail.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
