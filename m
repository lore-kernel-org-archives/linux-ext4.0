From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Thu, 13 Nov 2014 14:41:47 +0000
Message-ID: <bug-86471-13602-sZaXXNK1a5@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38178 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932910AbaKMOlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2014 09:41:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D0DED20212
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 14:41:48 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 725E6201F4
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 14:41:47 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D86471

--- Comment #11 from Markus K=C3=B6nigshaus <m.koenigshaus@wut.de> ---
Yes, correct.
Am 13.11.2014 um 15:33 schrieb bugzilla-daemon@bugzilla.kernel.org:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D86471
>
> --- Comment #10 from JPT <j-p-t@gmx.net> ---
> Found it: Was moved to here, correct?
> https://bugzilla.kernel.org/show_bug.cgi?id=3D86831
>

-- Unsere Aussagen koennen Irrtuemer und Missverstaendnisse enthalten.
Bitte pruefen Sie die Aussagen fuer Ihren Fall, bevor Sie Entscheidunge=
n=20
auf Grundlage dieser Aussagen treffen.
Wiesemann & Theis GmbH, Porschestr. 12, D-42279 Wuppertal
Geschaeftsfuehrer: Dipl.-Ing. Ruediger Theis
Registergericht: Amtsgericht Wuppertal, HRB 6377=20
Tel. +49-202/2680-0, Fax +49-202/2680-265, http://www.wut.de

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
