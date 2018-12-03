Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35584 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbeLCBER (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 20:04:17 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8D5C32A6CE
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 01:04:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 01:04:13 +0000
Message-ID: <bug-201685-13602-jXaCRDyCZh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #174 from Theodore Tso (tytso@mit.edu) ---
One of the reasons why this is bug hunt is so confounding.   While I was
looking at older reports to try to see if I could find common factors, I found
Jimmy's dmesg report in #50, and this one looks different from many of the
others that people have reported.   In this one, the EXT4 errors are preceeded
by a USB disconnect followed by disk-level errors.    

This is why it's important that we try very hard to filter out false positives
and false negative reports.  We have multiple reports which both strongly
indicate that it's an ext4 bug, and others which strongly indicate it is a bug
below the file system layer.   And then we have ones like this which look like
a USB disconnect....

[52967.931390] usb 4-1: reset SuperSpeed Gen 1 USB device number 2 using
xhci_hcd
[52968.985620] sd 8:0:0:2: [sdf] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00
driverbyte=0x08
[52968.985624] sd 8:0:0:2: [sdf] tag#0 Sense Key : 0x6 [current] 
[52968.985626] sd 8:0:0:2: [sdf] tag#0 ASC=0x28 ASCQ=0x0 
[52968.985628] sd 8:0:0:2: [sdf] tag#0 CDB: opcode=0x2a 2a 00 00 cc 60 28 00 08
00 00
[52968.985630] print_req_error: I/O error, dev sdf, sector 13393960
[52968.985641] EXT4-fs warning (device sdf2): ext4_end_bio:323: I/O error 10
writing to inode 522 (offset 6132072448 size 6295552 starting block 1674501)
[52968.985643] Buffer I/O error on device sdf2, logical block 1673728
[52968.985651] Buffer I/O error on device sdf2, logical block 1673729
[52968.985654] Buffer I/O error on device sdf2, logical block 1673730
[52968.985659] Buffer I/O error on device sdf2, logical block 1673731
[52968.985663] Buffer I/O error on device sdf2, logical block 1673732
...
[52968.986231] EXT4-fs warning (device sdf2): ext4_end_bio:323: I/O error 10
writing to inode 522 (offset 6132072448 size 8388608 starting block 1675013)
[52969.435367] JBD2: Detected IO errors while flushing file data on sdf2-8
[52969.435407] Aborting journal on device sdf2-8.
[52969.435422] JBD2: Error -5 detected when updating journal superblock for
sdf2-8.
[52969.441997] EXT4-fs error (device sdf2): ext4_journal_check_start:61:
Detected aborted journal
[52985.065239] EXT4-fs error (device sdf2): ext4_remount:5188: Abort forced by
user

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
