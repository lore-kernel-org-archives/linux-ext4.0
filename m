From: Curtis Jones <curtis.jones@gmail.com>
Subject: Can't resize2fs - combination of flex_bg and !resize_inode
Date: Mon, 20 Aug 2012 03:18:35 -0400
Message-ID: <0FB0C67C-CF56-4589-857F-8B57BC25AB7D@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61671 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTHSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Aug 2012 03:18:38 -0400
Received: by yhmm54 with SMTP id m54so4841903yhm.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2012 00:18:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. I hope this is the right list for ext4-related user questions. If not, please point me in the right direction.

I recently set up my first software raid with mdadm and after adding more disks to the raid I am unable to resize the filesystem to the full size of the raid. I created a single (~16TB) filesystem on /dev/md0 via:

	mkfs.ext4 -v -b 4096 -t huge -E stride=128,stripe-width=256 /dev/md0

I then waited painfully for a couple of days as all of the data from the old raid copied over to the new raid; I moved over the disks and grew the raid and then finally I:

	resize2fs -p /dev/md0

Which informs me that

	resize2fs 1.42 (29-Nov-2011)
	resize2fs: /dev/md0: The combination of flex_bg and !resize_inode features is not supported by resize2fs

I lack any understanding of exactly what these two features are for or why the combination is troublesome, so against my better judgement I tried to add resize_inode:

	tune2fs -O +resize_inode /dev/md0

But I got shot down:

	Setting filesystem feature 'resize_inode' not supported.

And I'm not brave enough to try to remove flex_bg as I really don't want to do anything that might put my data at risk. I'm running Ubuntu 12.04 with the 3.5.1 kernel:

	Linux critter 3.5.1-030501-generic #201208091310 SMP Thu Aug 9 17:11:48 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

While I await any suggestions, I'm going to look at a more up-to-date versions of these tools. Please let me know if I need to provide any more information. I *really* would like to find out that there's a way to resize the fs without having to recreate the fs. Copying all of this data off and back on would be painful.

Any help would be appreciated.

Thanks.

--
Curtis Jones

