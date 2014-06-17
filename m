From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78151] e2image -I does not work on ext4?
Date: Tue, 17 Jun 2014 12:41:54 +0000
Message-ID: <bug-78151-13602-0EENxft3BQ@https.bugzilla.kernel.org/>
References: <bug-78151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbaFQMl4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 08:41:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D831320306
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 12:41:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 683FB202D1
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 12:41:54 +0000 (UTC)
In-Reply-To: <bug-78151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78151

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
This isn't a kernel bug, but in any case, the original purpose of e2image was
to save the static file system metadata.  I should update the man page to
insert the word "static", but realistically, e2image -I was always a party
trick.  The form of the part trick was:

e2image /dev/hda1 /tmp/hda1.e2i
mke2fs -t ext4 /dev/hda1
e2image -I /dev/hda1.img /tmp/hda1.e2i
e2fsck -f /dev/hda1.img

The root directory will have been toasted, so all of the top-level directories
will be in lost+found, but it will allow you to recover all of the files and
most of the directory hierarchy with a minimum of effort.

The e2image -r command will save the directory inodes as well, but we never
implemented an e2image -I that would work with the raw e2image.  The main
utility of e2image -r is to extract enough file system metadata that you can
run e2image on the image, for the purposes of debugging e2fsck problems (see
the e2image man page for more details).

What is it that you are trying to *do*?   In general, the directory metadata
tends to be fairly unstable, so the utility of backing up the directory inodes
is relatively small.   If you are trying to recover after an accidental rm -rf,
unless the fs metadata snapshot was taken *right* before the rm -rf (which is
highly unlikely if the rm -rf was accidental), it's not really going to work.   

If you are trying to protect against sysadmin mistakes, the best thing to do is
traditional backups.   The e2image file could potentially save you against a
trashed inode table block, and so one of the things I've thought about doing is
making e2fsck use a backup metadata block from an e2i file if the metadata
checksum was incorrect.  Again, unless the e2image file was very recent, it
might not be that helpful, but it's better than nothing.  But a selective use
of a single trashed metadata block is much more likely to be useful than a
wholesale use of all of the static metadata blocks via e2image -I.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
