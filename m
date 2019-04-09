Return-Path: <SRS0=i6rR=SL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB91C282CE
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 07:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E124820651
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 07:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfDIH5a convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:57:30 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46744 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbfDIH5a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2019 03:57:30 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D387C28896
        for <linux-ext4@vger.kernel.org>; Tue,  9 Apr 2019 07:57:29 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id C74EA288A0; Tue,  9 Apr 2019 07:57:29 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 104571] ext4_mb_generate_buddy block bitmap and bg descriptor
 inconsistent
Date:   Tue, 09 Apr 2019 07:57:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dpsenner@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-104571-13602-z38Hxex8Uf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-104571-13602@https.bugzilla.kernel.org/>
References: <bug-104571-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=104571

dpsenner (dpsenner@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dpsenner@gmail.com

--- Comment #6 from dpsenner (dpsenner@gmail.com) ---
We were recently hit by this issue, too on a physical x64 machine that hosts
one kvm virtual machine guest with a windows server 2016 x64 operating system.
The filesystem is a mdadm software raid1 spanning over two disks with ext4
on-top.

$ uname -r
4.15.0-43-generic

$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 18.04.1 LTS
Release:        18.04
Codename:       bionic

The filesystem of the physical machine went read only and effectively crashed
all processes, including the guest operating system. A hard reset and disk
check appears to have solved the symptom, but we have mixed feelings since we
don't know about any collateral damage this may have caused. dmesg displays
worrying information that is hopefully not a symptom of irreversible root
filesystem corruption:

systemd-journald[457]: File
/var/log/journal/7346ea28f12b763f29b8995058d63291/user-1000.journal corrupted
or uncleanly shut down, renaming and replacing.

The symptom manifested while booting the guest machine and thus may well be
related to a burst of random reads and writes of the kvm guest. We observed
moderate disk activity in htop.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
