From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sat, 12 Oct 2013 00:19:48 +0000
Message-ID: <bug-61631-13602-YROHoA14sU@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34689 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3JLATv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 20:19:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C4AEB2039A
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:19:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B240D2038C
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:19:48 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #12 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
Created attachment 110781
  --> https://bugzilla.kernel.org/attachment.cgi?id=110781&action=edit
dmesg output after umount and bug_on

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
