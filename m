From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102751] infinite loop in jbd2_journal_destroy()
Date: Wed, 12 Aug 2015 22:38:45 +0000
Message-ID: <bug-102751-13602-Ui1nIYpciR@https.bugzilla.kernel.org/>
References: <bug-102751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53253 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbbHLWit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Aug 2015 18:38:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 507102070E
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 22:38:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E1FC1206D5
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 22:38:45 +0000 (UTC)
In-Reply-To: <bug-102751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D102751

Mihai Don=C8=9Bu <mihai.dontu@gmail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
           Hardware|All                         |x86-64

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
