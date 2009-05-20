From: Matt LaPlante <cybrmatt@gmail.com>
Subject: Mounting Ext3 with Ext4
Date: Wed, 20 May 2009 19:24:02 -0400
Message-ID: <baab8ccb0905201624j56767f59mff537ab8767ffc8d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50715 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZETXYC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 19:24:02 -0400
Received: by ewy24 with SMTP id 24so891382ewy.37
        for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 16:24:02 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

According to the Ext4 howto
(http://ext4.wiki.kernel.org/index.php/Ext4_Howto#Converting_an_ext3_filesystem_to_ext4),
"It is possible to mount both ext3 (and ext2, in kernels 2.6.28 and
later) filesystems directly using the ext4 filesystem driver."  So
this means, if I'm reading it correctly, that a kernel built with ext4
support should be able to mount and manage ext[234] filesystems.  Is
that correct?  If so, are there any limitations on this support?

I'm running Ubuntu Jaunty with some custom-built 2.6.29.4 kernels and
grub2.  I seem to have no problem booting from ext4 disks, so the ext4
support is definitely there and functioning.  I had hoped the ext3
support meant I could build the kernel with ext4 only and carry on as
usual with my ext3 partitions.  Unfortunately doing so causes the ext3
partitions to fail to boot.  So...

booting ext3 with ext3 in the kernel=fine
booting ext4 with ext4 in the kernel=fine
booting ext3 with ext4 (only) in the kernel=not fine

Is this a problem or was it never intended to work?
