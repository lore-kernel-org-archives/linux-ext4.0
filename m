Return-Path: <SRS0=VzNY=SO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F5EC10F0E
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 19:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F391D20869
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 19:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfDLTd7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Apr 2019 15:33:59 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39824 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbfDLTd7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Apr 2019 15:33:59 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7645628E89
        for <linux-ext4@vger.kernel.org>; Fri, 12 Apr 2019 19:33:58 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 6AB6E28EEA; Fri, 12 Apr 2019 19:33:58 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203247] jbd2 gets stuck at jbd2_journal_commit_transaction
 frequently
Date:   Fri, 12 Apr 2019 19:33:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext3
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: pankajcabs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext3@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203247-13602-oo3EFiaPsa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203247-13602@https.bugzilla.kernel.org/>
References: <bug-203247-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203247

--- Comment #9 from pkb07815 (pankajcabs@gmail.com) ---
Here is the complete information about disk:

# /opt/MegaRAID/MegaCli/MegaCli64 -pdlist -aALL

Adapter #0

Enclosure Device ID: 252
Slot Number: 0
Drive's position: DiskGroup: 0, Span: 0, Arm: 0
Enclosure position: N/A
Device Id: 6
WWN: 5000C500A167B624
Sequence Number: 2
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SAS

Raw Size: 558.911 GB [0x45dd2fb0 Sectors]
Non Coerced Size: 558.411 GB [0x45cd2fb0 Sectors]
Coerced Size: 558.406 GB [0x45cd0000 Sectors]
Sector Size:  0
Logical Sector Size:  0
Physical Sector Size:  0
Firmware state: Online, Spun Up
Commissioned Spare : No
Emergency Spare : No
Device Firmware Level: N003
Shield Counter: 0
Successful diagnostics completion on :  N/A
SAS Address(0): 0x5000c500a167b625
SAS Address(1): 0x0
Connected Port Number: 0(path0) 
Inquiry Data: SEAGATE ST600MM0088     N003W420R7PJ            
FDE Capable: Not Capable
FDE Enable: Disable
Secured: Unsecured
Locked: Unlocked
Needs EKM Attention: No
Foreign State: None 
Device Speed: Unknown 
Link Speed: 6.0Gb/s 
Media Type: Hard Disk Device
Drive:  Not Certified
Drive Temperature :28C (82.40 F)
PI Eligibility:  No 
Drive is formatted for PI information:  No
PI: No PI
Port-0 :
Port status: Active
Port's Linkspeed: 6.0Gb/s 
Port-1 :
Port status: Active
Port's Linkspeed: Unknown 
Drive has flagged a S.M.A.R.T alert : No

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
