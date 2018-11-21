Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:53884 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbeKVBXe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 20:23:34 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3D6112BAAE
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2018 14:48:50 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Wed, 21 Nov 2018 14:48:50 +0000
Message-ID: <bug-201685-13602-IYuLU9rLE8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #10 from Jimmy.Jazz@gmx.net ---
(In reply to Jimmy.Jazz from comment #8)

typo: read -rc2 not -rc3

I'm using rc3 release now. /etc/mke2fs.conf default_mntopts user_xattr is
deactivated (tune2fs -o ^user_xattr /dev/mapper/xx) on all my lvm devices.
Native mdp devices still have the option set.
One of my machines is always on heavy load because of daily compilations basis
I do in a nilfs sandbox environment. No error for the moment.

The issue was all of sudden and affected all my lvm devices. Next reboot, fsck
randomly couldn't "see" any failure the kernel had reported but detection
improved when used with the -D optimization option.

It could be some old corruptions undetected until now. One of the server is
more then 5 years old without reinstall but still with regular updates. But the
other one still has the issue at its first installation.

The kernel was compiled with GCC and LD=ld.bfd
I was unsuccessful with CLANG.

# gcc --version
gcc (Gentoo 8.2.0-r4 p1.5) 8.2.0

I'm bit puzzled.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
