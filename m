From: Doug Hunley <doug@hunley.homeip.net>
Subject: quick question on journal_checksum
Date: Fri, 12 Jun 2009 14:15:22 -0400
Message-ID: <7284e2210906121115r14c1cd52xa23a072009349759@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:59066 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZFLSPV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jun 2009 14:15:21 -0400
Received: by ewy6 with SMTP id 6so3210990ewy.37
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jun 2009 11:15:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If one specifies journal_checksum as a mount option for an ext4
rootfs, it should show up in the output of 'mount', yes? I'm not
seeing it.

My grub line:
kernel /boot/vmlinuz-2.6.30-gentoo-r1 rw vga=0x31B
video=vesafb:1280x1024-24,mtrr:3,ywrap hpet=force fastboot quiet
forcedeth.msi=1 forcedeth.msix=1 forcedeth.dma_64bit=1 root=/dev/md3
rootfstype=ext4 rootflags=journal_checksum

and the 'mount' output:
rootfs on / type rootfs (rw)
/dev/root on / type ext4 (rw,relatime,barrier=1,data=writeback)

Is this related to barriers failing? From dmesg:
JBD: barrier-based sync failed on md3:8 - disabling barriers

Thanks
-- 
Douglas J Hunley - doug@hunley.homeip.net
http://douglasjhunley.com
Twitter: @hunleyd
