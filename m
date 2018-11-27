Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52676 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbeK0XWN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 18:22:13 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 358992B033
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2018 12:24:28 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 27 Nov 2018 12:24:28 +0000
Message-ID: <bug-201685-13602-AJlvthpAV7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #55 from Jimmy.Jazz@gmx.net ---
I didn't make it with 4.18.0-radeon-07013-g54dbe75bbf-dirty because the radeon
module gives me a black screen.

With 4.18.0-radeon-03131-g0a957467c5-dirty, ext4 filesystems were stable but
2hours later an exception followed by a sudden reboot w/o warning. Next try,
immediate reboot.
Also bad too.

During bzImage compilation, ld returned:
ld.bfd: arch/x86/boot/compressed/head_64.o: warning: relocation in read-only
section `.head.text'
ld.bfd: warning: creating a DT_TEXTREL in object

Is that something suspicious for you?

FIK, I was stuck many times with the following message until I realized
usr/.initramfs_data.cpio.xz.d file were not removed from the directory (sig).

# make                                                                 
  CALL    scripts/checksyscalls.sh
  DESCEND  objtool
  CHK     include/generated/compile.h
usr/Makefile:48: *** motifs de cible multiples. Arrêt.
make: *** [Makefile:1041: usr] Error 2

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
