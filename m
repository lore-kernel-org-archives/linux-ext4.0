From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Mon, 25 Nov 2013 17:01:12 -0500
Message-ID: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: open list <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

Using 3.12.0 and ext4fs with 2 x SSDs in a RAID-1 configuration on a
3ware HW RAID card, no md/dm, I noticed the following recently:
[178339.353565] sda2: WRITE SAME failed. Manually zeroing.

It seems to be similar to this issue here:
http://permalink.gmane.org/gmane.linux.kernel/1494512

Relevant logs:
[178339.353519] 3w-sas: scsi0: ERROR: (0x03:0x0101): Invalid command
opcode:opcode=0x41.
[178339.353565] sda2: WRITE SAME failed. Manually zeroing.

Is this something I should be worried about?
I am running a database on the host, could that be the cause of it?
(in the related post, he was also running a DB).

Justin.
