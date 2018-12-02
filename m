Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49736 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbeLBNfq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 08:35:46 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 04A6A2AB0C
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 13:35:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 13:35:42 +0000
Message-ID: <bug-201685-13602-FrXBraUxsN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

Daniel Harding (dharding@living180.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dharding@living180.net

--- Comment #143 from Daniel Harding (dharding@living180.net) ---
Another datapoint:  I have observed Ext4 metadata corruption under both 4.19.1
and 4.19.4.  I'm using LVM (but no RAID); the underlying drive is a 1GB
SATA-attached Samsung 850 PRO SSD.  I've not been able to reliably reproduce,
but an rsync-based backup of my home partition runs once an hour and it usually
starts reporting corruption errors within a day or two of booting a 4.19.x
kernel.  So far the corruption has only happened in directories that I am not
actively using - as far as I know they are only being accessed by the rsync
process.  Since I started seeing the corruption under 4.19.x, I've run 4.18.16
for two stretches, one of which was twelve days, without any problems, so I'm
quite confident it is not an issue of defective hardware.  I have a weekly cron
job which runs fstrim, but at least once I booted into 4.19.4 (previous boot
was 4.18.16), and started seeing metadata corruption after about 36 hours, but
fstrim had not run during that time.

Some (possibly) relevant kernel configs:
CONFIG_SCSI_MQ_DEFAULT=y
# CONFIG_DM_MQ_DEFAULT is not set
# CONFIG_MQ_IOSCHED_DEADLINE is not set
# CONFIG_MQ_IOSCHED_KYBER is not set
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
# CONFIG_DEV_DAX is not set
# CONFIG_FS_DAX is not set

$ cat /sys/block/sda/queue/scheduler
[none] bfq

I'm happy to report any more info about my kernel/system if it would be
helpful, but unfortunately I don't have the bandwidth to do any bisection right
now.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
