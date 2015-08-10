From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102621] Directory name or file name staring with '-' cannot be
 handled through command line,i.e.,terminal
Date: Mon, 10 Aug 2015 17:36:31 +0000
Message-ID: <bug-102621-13602-PugbzxioPO@https.bugzilla.kernel.org/>
References: <bug-102621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbbHJRge (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Aug 2015 13:36:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 12C8920627
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2015 17:36:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9CBAC205DD
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2015 17:36:31 +0000 (UTC)
In-Reply-To: <bug-102621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102621

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen <sandeen@redhat.com> ---
Not a bug, kernel or otherwise.  You're simply seeing mkdir & touch interpret
"-t" as an option.  Preface with "./" to avoid this:

[sandeen@sandeen ~]$ mkdir ./-testdir
[sandeen@sandeen ~]$ cd ./-testdir
[sandeen@sandeen -testdir]$ pwd
/home/sandeen/-testdir
[sandeen@sandeen -testdir]$ touch ./-test
[sandeen@sandeen -testdir]$ ls -l
total 0
-rw-rw-r--. 1 sandeen sandeen 0 Aug 10 12:34 -test

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
