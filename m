From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 17:09:01 +0800
Message-ID: <20120227090901.GA13953@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61144 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2B0JED (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 04:04:03 -0500
Received: by pbcup15 with SMTP id up15so1842924pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2012 01:04:02 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

Now, in ext4, we have multi-block allocation and delay allocation. They work
well for most scenarios. However, in some specific scenarios, they cannot help
us to optimize block allocation. For example, the user may want to indicate some
file set to be allocated at the beginning of the disk because its speed in this
position is faster than its speed at the end of disk.

I have done the following experiment. The experiment is on my own server, which
has 16 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 48G memory and a 1T sas disk. I
split this disk into two partitions, one has 900G, and another has 100G. Then I
use dd to get the speed of read/write. The result is as following.

[READ]
# dd if=/dev/sdk1 of=/dev/null bs=128k count=10000 iflag=direct
1310720000 bytes (1.3 GB) copied, 9.41151 s, 139 MB/s

# dd if=/dev/sdk2 of=/dev/null bs=128k count=10000 iflag=direct
1310720000 bytes (1.3 GB) copied, 17.952 s, 73.0 MB/s

[WRITE]
# dd if=/dev/zero of=/dev/sdk1 bs=128k count=10000 oflag=direct
1310720000 bytes (1.3 GB) copied, 8.46005 s, 155 MB/s

# dd if=/dev/zero of=/dev/sdk2 bs=128k count=10000 oflag=direct
1310720000 bytes (1.3 GB) copied, 15.8493 s, 82.7 MB/s

So filesystem can provide a new feature to let the user to indicate a value
for reserving some blocks from the beginning of the disk. When the user needs
to allocate some blocks for an important file that needs to be read/write as
quick as possible, the user can use ioctl(2) and/or other ways to notify
filesystem to allocate these blocks in the reservation area. Thereby, the user
can obtain the higher performance for manipulating this file set.

This idea is very trivial. So any comments or suggestions are appreciated.

Regards,
Zheng
