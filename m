From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Thu, 23 Oct 2014 10:34:39 +0000
Message-ID: <bug-86471-13602-uBbQug1eOc@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42730 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbaJWKem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2014 06:34:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 597D420270
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 10:34:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BCFEE20268
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 10:34:39 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D86471

--- Comment #5 from Markus K=C3=B6nigshaus <m.koenigshaus@wut.de> ---
Hello Theodore,
I really wait a long time and I have the kernel dropped all Caches with
/proc/sys/vm/drop_caches, so I do not thing, there are left buffered wr=
ites
from mysqld. I can reproduce that behavior, before mysql shutdown I get=
 14
MB/s, after I get 400 kB/s with dd.=20
I will try to compile blktrace for our system later, not enough time fo=
r that
now. Can blktrace show me how often the writeback - mechanism writes th=
e cache
back to e.mmc - card?

Markus

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
