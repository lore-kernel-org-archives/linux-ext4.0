Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30460C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 18:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04150206BA
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 18:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbfDJSB6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 14:01:58 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47386 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728749AbfDJSB6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 14:01:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2A82C28C6D
        for <linux-ext4@vger.kernel.org>; Wed, 10 Apr 2019 18:01:58 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 1ED4328C5C; Wed, 10 Apr 2019 18:01:58 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203247] jbd2 gets stuck at jbd2_journal_commit_transaction
 frequently
Date:   Wed, 10 Apr 2019 18:01:57 +0000
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
Message-ID: <bug-203247-13602-BuELH1UHgj@https.bugzilla.kernel.org/>
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

--- Comment #6 from pkb07815 (pankajcabs@gmail.com) ---
I have tried with noop, CFQ and deadline, same results.

Io is mainly related to /data partition, which is mounted as :

/dev/sda9 on /var type ext3 (rw,noatime)
/dev/sda10 on /data type ext3 (rw,noatime,barrier=0)

/var mainly has logging part. We have lot of db traffic (postgres) flowing
under /data.
I have also tried writeback instead of ordered (default) for /data.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
