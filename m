From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114301] jbd2_journal_write_revoke_records
Date: Wed, 30 Mar 2016 09:19:26 +0000
Message-ID: <bug-114301-13602-6y0qSrejTf@https.bugzilla.kernel.org/>
References: <bug-114301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60857 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbcC3JTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2016 05:19:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 03B002035B
	for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 09:19:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 274432035E
	for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 09:19:27 +0000 (UTC)
In-Reply-To: <bug-114301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D114301

jia he <hejiash@cn.ibm.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |hejiash@cn.ibm.com

--- Comment #4 from jia he <hejiash@cn.ibm.com> ---
(In reply to xierui1010 from comment #3)
> Dear=EF=BC=8Cthe system under load.I can't to reproduce this problem.
> Thank you for your help!

Hi xierui
I wonder whether you are using emulex be2net network driver.
And I got the similar call trace with you. Need to collect some common =
symptoms
for the memory corruption

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
