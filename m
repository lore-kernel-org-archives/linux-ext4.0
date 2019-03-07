Return-Path: <SRS0=bGTj=RK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C119EC4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Mar 2019 08:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA5120851
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Mar 2019 08:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfCGIjw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Mar 2019 03:39:52 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34492 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbfCGIjv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2019 03:39:51 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 692952DEF8
        for <linux-ext4@vger.kernel.org>; Thu,  7 Mar 2019 08:39:50 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 5D8622DF1C; Thu,  7 Mar 2019 08:39:50 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202809] New: ext4: ext4_xattr_ibody_get:591: comm
 systemd-journal: corrupted in-inode xattr
Date:   Thu, 07 Mar 2019 08:39:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: feng.tang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-202809-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202809

            Bug ID: 202809
           Summary: ext4: ext4_xattr_ibody_get:591: comm systemd-journal:
                    corrupted in-inode xattr
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.23-19
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: feng.tang@intel.com
        Regression: No

Created attachment 281569
  --> https://bugzilla.kernel.org/attachment.cgi?id=281569&action=edit
fsck output

When we run some stress test on our platform, we saw error message like this:

[49074.700194] EXT4-fs error (device mmcblk1p1): ext4_xattr_ibody_get:591:
inode #164242: comm systemd-journal: corrupted in-inode xattr
[49074.701633] EXT4-fs error (device mmcblk1p1): ext4_xattr_ibody_get:591:
inode #164247: comm systemd-journal: corrupted in-inode xattr
[49074.703260] EXT4-fs error (device mmcblk1p1): ext4_xattr_ibody_get:591:
inode #164245: comm systemd-journal: corrupted in-inode xattr
[49079.621065] EXT4-fs error: 39 callbacks suppressed

kernel version is 4.19.23-19.
CPU: Intel(R) Atom(TM) Processor A3960 @ 1.90GHz
rootfs: emmc storage card
Running on top of a hypervisor (ACRN)

When the error message happens, the GUI will stop working, sometimes the serial
console will stop too, but we can still connect to it through SSH connections,
and if we run fsck on that system, will see some error info (full log
attached).

some are:

Multiply-claimed block(s) in inode 164223: 656535
Multiply-claimed block(s) in inode 164224: 673971 757260--758282
Multiply-claimed block(s) in inode 164225: 656531

File
/var/log/journal/cf5c3ff473bd4a2dbfc890565e0439f9/system@e2d41008f0ce4d53849cdc7cec0f8a29-000000000003045c-0005831a9bb56af7.journal
(inode #164224, mod time Sat Mar  2 11:13:48 2019)
  has 1024 multiply-claimed block(s), shared with 1 file(s):
        /var/log/crashlog/vmevent393_98cd58c91b1da34b635e/crashfile (inode
#164240, mod time Sat Mar  2 11:13:48 2019)

Could you please help to check, and provide some hints for debugging? thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
