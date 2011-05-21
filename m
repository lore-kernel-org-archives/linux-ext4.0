From: Lee Davis <l.davis37@ymail.com>
Subject: EXT4 partition changes every time it's mounted. (How to stop this?)
Date: Sat, 21 May 2011 12:45:32 -0700 (PDT)
Message-ID: <476510.14310.qm@web125206.mail.ne1.yahoo.com>
Reply-To: Lee Davis <l.davis37@ymail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm19-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.149]:25583 "HELO
	nm19-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752873Ab1EUTvc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 May 2011 15:51:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

I'm setting up a Linux system with full disk encryption. I've written a script (to run on every boot) which will verify that neither the MBR or /boot partition (ext4) has been modified.

Problem is that every time I boot up the system, my /boot partition hashes differently.

Trying to solve this, I set the /boot partition to mount as read only in fstab. I then took individual hashes of every file on /boot. After I rebooted none of the files had changed (and there were no new files), yet the filesystem hashed as a whole had changed.

I'm guessing there is something behind the scenes which is changed/updated each time the filesystem is mounted? If so, can it be disabled?

Any advice would be greatly appreciated!

Cheers,
Lee

