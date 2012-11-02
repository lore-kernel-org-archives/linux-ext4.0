From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Fri,  2 Nov 2012 15:20:25 +0000 (UTC)
Message-ID: <20121102152025.730DA11FB5A@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57179 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab2KBPU2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 11:20:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B1B6202FD
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 15:20:27 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 029F0202BA
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 15:20:26 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723


Benjamin Schanzel <b.schanzel@googlemail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |b.schanzel@googlemail.com




--- Comment #10 from Benjamin Schanzel <b.schanzel@googlemail.com>  2012-11-02 15:20:25 ---
I also get this error every few days. Using Fedora 17
3.6.3-1.fc17.x86_64

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
