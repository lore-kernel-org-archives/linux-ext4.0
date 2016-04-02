From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88321] WARNING: CPU: 1 PID: 6784 at fs/dcache.c:1318
 umount_check+0x77/0x7b()
Date: Sat, 02 Apr 2016 15:56:20 +0000
Message-ID: <bug-88321-13602-ApMjTNAebN@https.bugzilla.kernel.org/>
References: <bug-88321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33992 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbcDBP4X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Apr 2016 11:56:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3831E2038E
	for <linux-ext4@vger.kernel.org>; Sat,  2 Apr 2016 15:56:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3EDF920386
	for <linux-ext4@vger.kernel.org>; Sat,  2 Apr 2016 15:56:21 +0000 (UTC)
In-Reply-To: <bug-88321-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=88321

nickkrause@sympatico.ca changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nickkrause@sympatico.ca

--- Comment #1 from nickkrause@sympatico.ca ---
In the function nfs_kill_super for the file fs/nfs/super.c from the root of the
kernel directory can you add:
nfs_put_client(server->nfs_client)
before:
generic_shutdown_super(s);
and see if that fixes your issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
