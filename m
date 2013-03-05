From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Tue,  5 Mar 2013 00:18:41 +0000 (UTC)
Message-ID: <20130305001841.0E88711FDD3@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57916 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900Ab3CEASr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Mar 2013 19:18:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 17B182032D
	for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2013 00:18:45 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D183C20335
	for <linux-ext4@vger.kernel.org>; Tue,  5 Mar 2013 00:18:42 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723





--- Comment #15 from Birger Harzenetter <wimpy@yeti.dk>  2013-03-05 00:18:40 ---
I haven't done extensive testing due to other issues, but at lest 3.7.0 and
3.8.0 seem to be ok.

However immediately thereafter (git linux-stable) I got random contents.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
