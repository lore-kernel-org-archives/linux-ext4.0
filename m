From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 117421] e2fsprogs: mke2fs ignores sparse_super2 when also using
 extent or 64bit
Date: Mon, 09 May 2016 02:47:06 +0000
Message-ID: <bug-117421-13602-2ed9Jka1Nb@https.bugzilla.kernel.org/>
References: <bug-117421-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbcEICrL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2016 22:47:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1E9320142
	for <linux-ext4@vger.kernel.org>; Mon,  9 May 2016 02:47:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 365F32012D
	for <linux-ext4@vger.kernel.org>; Mon,  9 May 2016 02:47:07 +0000 (UTC)
In-Reply-To: <bug-117421-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=117421

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
