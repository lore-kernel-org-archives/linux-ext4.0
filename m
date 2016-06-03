From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Fri, 03 Jun 2016 19:03:03 +0000
Message-ID: <bug-118401-13602-QDxutwZ6In@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54942 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbcFCTDJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2016 15:03:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 686E720279
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jun 2016 19:03:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C6C4420272
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jun 2016 19:03:05 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #17 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 218851
  --> https://bugzilla.kernel.org/attachment.cgi?id=218851&action=edit
phone-image of initramfs-script w/ahci, scsi dmesg's, 4.6

$ cat /etc/initramfs-tools/scripts/init-premount/kbu-blkid 
#!/bin/sh
PREREQ=""
prereqs()
{
     echo "$PREREQ"
}

case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac

echo "KBU"
echo 'cat /proc/partitions # gives:'
      cat /proc/partitions
echo '/sbin/blkid # gives:'
      /sbin/blkid
echo 'cat /proc/cmdline # gives:'
      cat /proc/cmdline
echo 'dmesg | grep -i blocks # gives:'
      dmesg | grep -i blocks
echo 'dmesg | grep -i ahci # gives:'
      dmesg | grep -i ahci
echo 'dmesg | grep -i scsi # gives:'
      dmesg | grep -i scsi
echo 'dmesg | grep -i sata # gives:'
      dmesg | grep -i sata
echo 'dmesg | grep -i  ata[0-4] # gives:'
      dmesg | grep -i  ata[0-4]
echo 'cat /proc/scsi/scsi # gives:'
      cat /proc/scsi/scsi
echo "/KBU"

$ cat /etc/initramfs-tools/modules 
# List of modules that you want to include in your initramfs.
# They will be loaded at boot time in the order below.
#
# Syntax:  module_name [args ...]
#
# You must run update-initramfs(8) to effect this change.
#
# Examples:
#
# raid1
# sd_mod
ahci
libahci

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
