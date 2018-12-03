Return-Path: <SRS0=iZZ9=OM=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48372 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbeLCDIU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 22:08:20 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8C4AE2A95F
        for <linux-ext4@vger.kernel.org>; Mon,  3 Dec 2018 03:08:15 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Mon, 03 Dec 2018 03:08:14 +0000
Message-ID: <bug-201685-13602-nBXwfTKoVZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #184 from Lei Ming (tom.leiming@gmail.com) ---
The commit 2a5cf35cd6c56b2924("block: fix single range discard merge") in linus
tree may address one possible data loss, anyone who saw corruption in scsi
may try this fix and see if it makes a difference.

Given the merged discard request isn't removed from elevator queue, it might
be possible to be submitted to hardware again.(In reply to Theodore Tso from
comment #174)
> One of the reasons why this is bug hunt is so confounding.   While I was
> looking at older reports to try to see if I could find common factors, I
> found Jimmy's dmesg report in #50, and this one looks different from many of
> the others that people have reported.   In this one, the EXT4 errors are
> preceeded by a USB disconnect followed by disk-level errors.    
> 
> This is why it's important that we try very hard to filter out false
> positives and false negative reports.  We have multiple reports which both
> strongly indicate that it's an ext4 bug, and others which strongly indicate
> it is a bug below the file system layer.   And then we have ones like this
> which look like a USB disconnect....
> 
> [52967.931390] usb 4-1: reset SuperSpeed Gen 1 USB device number 2 using
> xhci_hcd

IMO it should be a usb device reset instead of disconnect, and reset
is often triggered in SCSI EH.

Thanks,

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
