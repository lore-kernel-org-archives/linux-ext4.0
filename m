From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 19:39:22 -0800 (PST)
Message-ID: <20090202033922.34B30108041@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbZBBDjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 22:39:24 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n123dMue015557
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 19:39:23 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #10 from avery@shadypixel.com  2009-02-01 19:39 -------
when download is hung:

avery@polar:~/downloads$ ls -l firefox*
-rw------- 1 avery avery       0 2009-02-01 22:32 firefox-3.0.5.tar.bz2
-rw------- 1 avery avery 9111221 2009-02-01 22:32 firefox-3.0.5.tar.bz2.part
avery@polar:~/downloads$ md5sum firefox-3.0.5.tar.bz2.part 
6638ab249ae75d8fd345b34c187e87d4  firefox-3.0.5.tar.bz2.part

after closing download window:

avery@polar:~/downloads$ ls -l firefox*
-rw------- 1 avery avery       0 2009-02-01 22:32 firefox-3.0.5.tar.bz2
-rw------- 1 avery avery 9112341 2009-02-01 22:33 firefox-3.0.5.tar.bz2.part
avery@polar:~/downloads$ md5sum firefox-3.0.5.tar.bz2.part 
9ee0b64ab41bb30c0be00ceb972f111c  firefox-3.0.5.tar.bz2.part

a good download:

avery@polar:~/downloads$ ls -l firefox-3.0.5.tar.bz2
-rw-r--r-- 1 avery avery 9112341 2009-02-01 22:36 firefox-3.0.5.tar.bz2
avery@polar:~/downloads$ md5sum firefox-3.0.5.tar.bz2
9ee0b64ab41bb30c0be00ceb972f111c  firefox-3.0.5.tar.bz2

so, it appears it actually completes the download. I'm not sure why it's not
completely written out before I close the window. 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
