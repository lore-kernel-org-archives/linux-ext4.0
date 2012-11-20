From: Ivan Zahariev <famzah@icdsoft.com>
Subject: Ext4 speedup by storing metadata and data on separate devices
Date: Tue, 20 Nov 2012 13:04:20 +0200
Message-ID: <50AB63B4.1050506@icdsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icdsoft.com ([64.14.68.165]:55369 "EHLO us.icdsoft.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2KTLLJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 06:11:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,

This suggestion is not about storing the journal on a separate device.

Many of the tasks on an Ext4 file-system require a full or massive scan 
of the metadata. A few examples:
- backup: you need to get a list with all "mtime" or "size" changed 
files since last backup
- reporting: you need to get a list with all files of a particular 
"group" owner ID
- delete: deleting the "/home/$user" of someone with lots of data and files

I know many efforts have been made to make the (meta)data operations 
"local" -- this speeds up spinning disks operations a lot, also SSD 
ones. However, having the whole metadata on an SSD disk (or a RAID1 of 
two such disks) could speed up many common tasks a lot. And the hardware 
price for such a benefit is really affordable now.

I see two possible implementations:

1. Re-work the Ext4 metadata operations (that work with inodes, etc) to 
read/write on a separate block device.

or

2. Add an option to the "data locality" algorithm to force it to store 
all metadata only at the beginning of a device (we can pre-allocate 
enough space). We can then transparently map in the DM those blocks to a 
separate faster block device, thus making the changes to Ext4 minimal.

Does all this make sense, or I'm missing something obvious?

Thank you for your time.

-- 
Best regards.
Ivan Zahariev | System Administrator | ICDSoft Ltd.

