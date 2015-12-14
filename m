From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] EXT4-fs (sda1): couldn't mount as ext3 due to feature
 incompatibilities
Date: Mon, 14 Dec 2015 16:12:58 +0000
Message-ID: <bug-109331-13602-M8aoWcluGs@https.bugzilla.kernel.org/>
References: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbLNQNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2015 11:13:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1EF86203AE
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 16:13:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C4198203C4
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2015 16:12:58 +0000 (UTC)
In-Reply-To: <bug-109331-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D109331

Huaitong Han <oenhan@gmail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |oenhan@gmail.com

--- Comment #3 from Huaitong Han <oenhan@gmail.com> ---
what's the result of executing =E2=80=9Cfile -s /dev/sda1=E2=80=9D ? I =
guess sda1 filesystem is
ext3.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
