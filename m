Return-Path: <SRS0=7ScE=O4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49092 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728067AbeLSXDW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Dec 2018 18:03:22 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F330D28807
        for <linux-ext4@vger.kernel.org>; Wed, 19 Dec 2018 23:03:21 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date: Wed, 19 Dec 2018 23:03:15 +0000
Message-ID: <bug-201631-13602-ZQak6xVtyM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #24 from Benjamin Herrenschmidt (benh@kernel.crashing.org) ---
Out of curiosity, how does this work in the context of pages that are GUPed
either by a driver or by KVM when using file backed guest memory ?

GUP will not "see" the mkclean or attempt at making read only...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
