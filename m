From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72401] EXT4-fs error (device sdf1):
 ext4_mb_complex_scan_group:1786: group 11890, 254 free clusters as per group
 info. But got 256 blocks
Date: Tue, 18 Mar 2014 08:38:24 +0000
Message-ID: <bug-72401-13602-k9SHgkxMUy@https.bugzilla.kernel.org/>
References: <bug-72401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44512 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaCSSD5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 14:03:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E5F8220382
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 08:38:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3C90920179
	for <linux-ext4@vger.kernel.org>; Tue, 18 Mar 2014 08:38:24 +0000 (UTC)
In-Reply-To: <bug-72401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=72401

WeiZhang <zweiustc@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|EXT4-fs error (device       |EXT4-fs error (device
                   |sdf1):                      |sdf1):
                   |ext4_mb_complex_scan_group: |ext4_mb_complex_scan_group:
                   |1786: group 11890254 free   |1786: group 11890, 254 free
                   |clusters as per group info. |clusters as per group info.
                   |But got 256 blocks          |But got 256 blocks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
