From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194695] New: size overflow detected in function
 ext4_mb_new_group_pa
Date: Fri, 24 Feb 2017 13:11:16 +0000
Message-ID: <bug-194695-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34294 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751265AbdBXNLS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 24 Feb 2017 08:11:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C41EE286E0
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 13:11:16 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 65A5C286E0
        for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2017 13:11:16 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194695

            Bug ID: 194695
           Summary: size overflow detected in function
                    ext4_mb_new_group_pa
           Product: File System
           Version: 2.5
    Kernel Version: 4.9.10-1+grsec201702162016+1
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: matthijs@cacholong.nl
        Regression: No

I am trying to run a kernel with grsecurity with the size overflow
protection and am getting the following warnings / errors:

dmesg: http://pastebin.com/wr3UGLS9
config: http://pastebin.com/sr8M9bP0
mballoc.* (make fs/ext4/mballoc.o EXTRA_CFLAGS="-fdump-tree-all
-fdump-ipa-all") http://filebin.ca/3DMIChVw9lQM/mballoc.tgz

According to the grsecurity developers it seems to be a bug in ext4, see for
some background here:
https://forums.grsecurity.net/viewtopic.php?f=1&t=4678&p=16971

The response from ephox (PAX team / grsecurity developer):
--
Thanks for the report. I think this is an upstream bug. Based on the
runtime values provided by you, ext4_mb_new_group_pa() tries to store a
value into pa->pa_lstart which larger than UINT_MAX which comes from
ext4_group_first_block_no().
Could you please report it to the ext4 developers?
--

I'll try to answer all the questions but I'm not an expert in this area.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
