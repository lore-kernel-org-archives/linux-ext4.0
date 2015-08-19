From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] New: auto_da_alloc mount option not working
Date: Wed, 19 Aug 2015 13:34:48 +0000
Message-ID: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbbHSNew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2015 09:34:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B382C207C3
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2015 13:34:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 546BD207BF
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2015 13:34:49 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D103111

            Bug ID: 103111
           Summary: auto_da_alloc mount option not working
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39
          Hardware: Intel
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: patelrakeshcomp@gmail.com
        Regression: No

As per the ext4 guide,
ext4 will detect the replace-via-rename and replace-via-truncate patter=
ns
              and force that any delayed allocation blocks are allocate=
d such
that at the next journal commit, in  the
              default data=3Dordered mode, the data blocks of the new f=
ile are
forced to disk before the rename() opera=E2=80=90
              tion is committed.


But it looks like this feature is not working anymore.

Kernel version: 2.6.39.
=46ilesystem: ext4

Here is the sample code:

  ofstream myfile;

  myfile.open ("example.txt",std::ofstream::trunc);

  myfile << "Writing this to a file.\n";

  system("mv example.txt example.txt1");

Expected behaviour: Ext4 should detect trunc() call and should allocate=
 blocks
for same. So there should be no zero-length file after abnormal
shutdown(withing 30sec).

Actual results: File is having zero-length after abnormal reboot(power =
outage).

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
