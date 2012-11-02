From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Fri,  2 Nov 2012 16:45:07 +0000 (UTC)
Message-ID: <20121102164507.2CC0411FB6C@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab2KBQpK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 12:45:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 149CE20182
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 16:45:09 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E969220208
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 16:45:07 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723





--- Comment #13 from Eric Sandeen <sandeen@redhat.com>  2012-11-02 16:45:06 ---
(In reply to comment #12)
> _Fedora-17-x86_6: recovering journal

Hm wonder why the journal was dirty ?

clearing orphaned inodes is fine

> Pass 1: Checking inodes, blocks, and sizes
> Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes
> Inode 791 was part of the orphaned inode list.  FIXED.
> Inode 1716 was part of the orphaned inode list.  FIXED.
> Inode 36947 was part of the orphaned inode list.  FIXED.
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  +(1262130--1262131) +1313070 -(1685212--1685213)
> Fix<y>? yes
> Free blocks count wrong for group #40 (11881, counted=11880).
> Fix<y>? yes
> Free blocks count wrong (11735574, counted=11735652).
> Fix<y>? yes

Those might have led to the errors you saw, let's see if that clears up the
runtime errors.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
