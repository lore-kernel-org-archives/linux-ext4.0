From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50261] New: Invalid d_type on readdir(), but e2fsck sees
 correct type
Date: Thu,  8 Nov 2012 09:40:08 +0000 (UTC)
Message-ID: <bug-50261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33718 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2KHJkM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 04:40:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1A7E20177
	for <linux-ext4@vger.kernel.org>; Thu,  8 Nov 2012 09:40:10 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 62BD0200E1
	for <linux-ext4@vger.kernel.org>; Thu,  8 Nov 2012 09:40:09 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50261

           Summary: Invalid d_type on readdir(), but e2fsck sees correct
                    type
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: bernd.schubert@fastmail.fm
        Regression: No


While writing the on-disk-format upgrade tool for the next fhgfs version, I
also added a sanity check for the hash-directories. And while testing it it
reported a problem:

* Migrating inodes... (Processing 8192 hash directories...)
* Progress: 
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/A7 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/177 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/739 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/835 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/D84 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/111C type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/13C1 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/15B7 type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/17EB type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/19CA type: 8
Warning entry is not a directory: /fhgfs/meta/meta.dir//entries/1FD4 type: 8

So somehow those few directories out of 8192 (for dentries and inodes, each, so
two times 8192) seem to have a wrong directory type. 
So I went ahead and checked if e2fsck would correct it. But e2fsck reported no
errors. So I went further ahead and added some debug code to e2fsck and indeed,
e2fsck sees the correct type:

inode: 6293106 nameLen: 4 entryName: 17EB fileType: 2 should_be: 2

(fprintf line in check_filetype() ).

For verification, the stat() output also looks right:

schubert@squeeze2 ~>stat /fhgfs/meta/meta.dir//entries/17EB
  File: `/fhgfs/meta/meta.dir//entries/17EB'
  Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: fe10h/65040d    Inode: 6293106     Links: 2
Access: (0755/drwxr-xr-x)  Uid: ( 5741/schubert)   Gid: (  100/   users)
Access: 2012-11-07 13:37:00.280689000 +0100
Modify: 2012-10-31 16:27:14.024689006 +0100
Change: 2012-10-31 16:27:14.024689006 +0100


So somehow either libc or kernel report a wrong file_type field for those
dentries. I will do some in-kernel debugging later on.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
