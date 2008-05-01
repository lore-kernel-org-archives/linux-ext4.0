From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: BUG in ext3_sync_fs
Date: Thu, 1 May 2008 13:33:38 +0200
Message-ID: <19f34abd0805010433x7634666bpf7de34248a394480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.244]:7700 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755314AbYEALdl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2008 07:33:41 -0400
Received: by rv-out-0506.google.com with SMTP id k29so536045rvb.1
        for <linux-ext4@vger.kernel.org>; Thu, 01 May 2008 04:33:38 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

With current git (+ kmemcheck, see below) patches I get the following
during boot:

BUG: unable to handle kernel paging request at 00001108
IP: [<c04effcf>] ext3_sync_fs+0x3f/+x80

I inserted some printks in ext3_sync_fs():
        printk(KERN_EMERG "sb = %p\n", sb);
        printk(KERN_EMERG "sb->s_fs_info = %p\n", sb->s_fs_info);

And they show:
sb = f7f61e00
sb->s_fs_info = 00000000

Monitorshot: http://folk.uio.no/vegardno/linux/DSCF2905.JPG
Config: http://folk.uio.no/vegardno/linux/config-20080501.txt

I am booting a USB stick with an ext2 filesystem as root partition. It
mounts fine in other machines.

It could of course be my kmemcheck patches that are causing this
(though I find it unlikely as they are disabled on boot => no-op, and
everything was fine a couple of days ago), but recompiling this config
takes a few hours, and I thought I'd just post early in case the
problem is really with ext3.

I can send vmlinux image and/or disk image if necessary.

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
