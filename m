From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Sat,  1 Jun 2013 09:22:22 +0000 (UTC)
Message-ID: <20130601092222.6D12411FB9B@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36925 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab3FAJW0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Jun 2013 05:22:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 841842051D
	for <linux-ext4@vger.kernel.org>; Sat,  1 Jun 2013 09:22:25 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6BAB920507
	for <linux-ext4@vger.kernel.org>; Sat,  1 Jun 2013 09:22:24 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723


Lukas Elsner <kernel@ccube.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kernel@ccube.de




--- Comment #16 from Lukas Elsner <kernel@ccube.de>  2013-06-01 09:22:21 ---
Hi, i know this thread is very old. But I am getting exactly this error on my
crucial M4 SSD. It happens every three days. This is a gentoo box with most
recent packages. (happened with 3.9 and 3.10rc kernel.) I am thinking about a
faulty hardware, but I really dont know. Any hints for me where to look at?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
