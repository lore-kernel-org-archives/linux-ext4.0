From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Mon, 16 Apr 2012 00:21:43 GMT
Message-ID: <201204160021.q3G0Lhvj012239@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:52180 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab2DPAVn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Apr 2012 20:21:43 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3G0Lhe1012240
	for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 00:21:43 GMT
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723


Robert Trace <bugzilla-kernel@farcaster.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bugzilla-kernel@farcaster.o
                   |                            |rg




--- Comment #3 from Robert Trace <bugzilla-kernel@farcaster.org>  2012-04-16 00:21:40 ---
I have a filesystem that exhibits the problem in the original mailing-list
post:

EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
  <copy data into the filesystem>
EXT4-fs error (device dm-3): ext4_mb_generate_buddy:738: group 186, 32764
blocks in bitmap, 32766 in gd
Aborting journal on device dm-3-8.
EXT4-fs (dm-3): Remounting filesystem read-only
EXT4-fs (dm-3): ext4_da_writepages: jbd2_start: 9223372036854775807 pages, ino
452; err -30

fsck'ing the filesystem will repair it.  Performing the exact same copy again
will reproduce the exact error.

I can reproduce this 100% of the time and have bisected it back to 

commit d5b8f31007a93777cfb0603b665858fb7aebebfc
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Sep 9 18:44:51 2011 -0400

    ext4: bigalloc changes to block bitmap initialization functions

    Add bigalloc support to ext4_init_block_bitmap() and
    ext4_free_blocks_after_init().

It's still present in Linus' tree as of
a9e1e53bcfb29b3b503a5e75ce498d9a64f32c1e (10-Apr).

I'm more than happy to help out with more information or testing patches since
I've got it 100% reproducible.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
