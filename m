From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sat, 12 Oct 2013 00:21:25 +0000
Message-ID: <bug-61631-13602-4fP23dGtTg@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34760 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3JLAV3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 20:21:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 97E0E2039D
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:21:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E159420396
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:21:25 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #13 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
Created attachment 110791
  --> https://bugzilla.kernel.org/attachment.cgi?id=110791&action=edit
debugfs -R 'stat <20035337>' /dev/md1 > debugfs.1 after umount/bug_on

Please let me know if there's anymore information I can provide.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
