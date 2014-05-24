From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] New: jbd2 write on disk each 5/6 seconds
Date: Sat, 24 May 2014 12:14:10 +0000
Message-ID: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39205 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaEXMOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 May 2014 08:14:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8D0CF201D5
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 12:14:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 35E8720149
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 12:14:11 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D76821

            Bug ID: 76821
           Summary: jbd2 write on disk each 5/6 seconds
           Product: File System
           Version: 2.5
    Kernel Version: 3.14.4-1-ARCH
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: abdelhak@cryptolab.net
        Regression: No

=E2=9E=9C  ~  sudo iotop -obtqqq | grep jbd2            =20
[sudo] password for hacko:=20
13:12:05   390 be/3 root        0.00 B/s    0.00 B/s  0.00 %  0.87 %
[jbd2/sda6-8]
13:12:06   390 be/3 root        0.00 B/s   31.45 K/s  0.00 %  2.48 %
[jbd2/sda6-8]
13:12:12   111 be/3 root        0.00 B/s   11.53 K/s  0.00 %  4.99 %
[jbd2/sda3-8]
13:12:19   390 be/3 root        0.00 B/s    3.84 K/s  0.00 %  2.98 %
[jbd2/sda6-8]
13:12:25   390 be/3 root        0.00 B/s    3.84 K/s  0.00 %  5.91 %
[jbd2/sda6-8]
13:12:25   111 be/3 root        0.00 B/s   23.03 K/s  0.00 %  5.71 %
[jbd2/sda3-8]
13:12:31   390 be/3 root        0.00 B/s    3.84 K/s  0.00 %  4.42 %
[jbd2/sda6-8]
13:12:32   390 be/3 root        0.00 B/s    0.00 B/s  0.00 %  0.03 %
[jbd2/sda6-8]
13:12:34   390 be/3 root        0.00 B/s   23.05 K/s  0.00 %  7.62 %
[jbd2/sda6-8]
13:12:39   390 be/3 root        0.00 B/s   26.86 K/s  0.00 %  4.40 %
[jbd2/sda6-8]
13:12:46   390 be/3 root        0.00 B/s    3.83 K/s  0.00 %  4.42 %
[jbd2/sda6-8]
13:12:53   390 be/3 root        0.00 B/s   11.49 K/s  0.00 %  4.31 %
[jbd2/sda6-8]
13:13:01   390 be/3 root        0.00 B/s   11.53 K/s  0.00 %  4.46 %
[jbd2/sda6-8]
13:13:07   390 be/3 root        0.00 B/s    7.69 K/s  0.00 %  4.55 %
[jbd2/sda6-8]
13:13:12   390 be/3 root        0.00 B/s   11.56 K/s  0.00 %  4.85 %
[jbd2/sda6-8]
13:13:19   390 be/3 root        0.00 B/s   11.56 K/s  0.00 %  4.27 %
[jbd2/sda6-8]
13:13:23   390 be/3 root        0.00 B/s   46.13 K/s  0.00 %  9.26 %
[jbd2/sda6-8]
13:13:26   390 be/3 root        0.00 B/s    7.54 K/s  0.00 %  6.05 %
[jbd2/sda6-8]
13:13:31   390 be/3 root        0.00 B/s   30.01 K/s  0.00 %  4.60 %
[jbd2/sda6-8]

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
