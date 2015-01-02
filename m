From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 02 Jan 2015 00:49:37 +0000
Message-ID: <bug-89511-13602-xL96m5tPZ2@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40944 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbbABAtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Jan 2015 19:49:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 102F22026C
	for <linux-ext4@vger.kernel.org>; Fri,  2 Jan 2015 00:49:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0A91020256
	for <linux-ext4@vger.kernel.org>; Fri,  2 Jan 2015 00:49:39 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D89511

--- Comment #33 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 162221
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D162221&action=3De=
dit
=46ile system fails

When test it, noticed, and "is write back"; mount->File system seems to=
 fail
when I do umount.
It is fdisk in "write through"->Using the HDD which performed mkfs.ext4=
 is.
It is mount in "write through"->An error does not occur in umount.
It is hard to look, but, please confirm an attached file.

=E2=80=BBExpression may be funny for machine translation,; but the perm=
ission.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
