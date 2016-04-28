From: "Lay, Kuan Loon" <kuan.loon.lay@intel.com>
Subject: EXT4 bad block
Date: Thu, 28 Apr 2016 09:44:16 +0000
Message-ID: <61AE2E6F29F7AC4182A7076FC3478CDAC217E7@PGSMSX101.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I encounter random bad block on different file, the message looks like "EXT4-fs error (device mmcblk0p14): ext4_xattr_block_get:298: inode #77: comm (syslogd): bad block 7288". 

I am using mke2fs 1.43-WIP (18-May-2015) and I saw this message "Suggestion: Use Linux kernel >= 3.18 for improved stability of the metadata and journal checksum features." print out. 

My current kernel version is 3.14.55, what patch I need to backport to solve the bad block issue?

Thanks

Best Regards,
Lay
