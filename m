From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Sat, 28 Jan 2017 12:52:16 +0000
Message-ID: <bug-187051-13602-0cSZhQAVW1@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750893AbdA1NKS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 28 Jan 2017 08:10:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D7CDB203E9
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2017 12:52:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id A4E062038A
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2017 12:52:16 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #9 from Hussam Al-Tayeb <me@hussam.eu.org> ---
Created attachment 253371
  --> https://bugzilla.kernel.org/attachment.cgi?id=253371&action=edit
logged trace

This is the crash data according to journalctl

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
