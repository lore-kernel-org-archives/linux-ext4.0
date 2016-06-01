From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 118401] Lenovo A740 gave up waiting for root device with
 kernels >= 4.3
Date: Wed, 01 Jun 2016 18:53:17 +0000
Message-ID: <bug-118401-13602-WDCQgNvgFG@https.bugzilla.kernel.org/>
References: <bug-118401-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbcFASxV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jun 2016 14:53:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F01A7203A9
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 18:53:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4CE9520398
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jun 2016 18:53:18 +0000 (UTC)
In-Reply-To: <bug-118401-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=118401

--- Comment #12 from Kevin Brubeck Unhammer <unhammer+dill@mm.st> ---
Created attachment 218671
  --> https://bugzilla.kernel.org/attachment.cgi?id=218671&action=edit
phone-image of output from initramfs-script

This is the updated script that lead to the output in the attachment:


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
echo 'cat /proc/partitions'
cat /proc/partitions
echo '/sbin/blkid'
/sbin/blkid
echo 'cat /proc/cmdline'
cat /proc/cmdline
echo 'dmesg | grep -i blocks'
dmesg | grep -i blocks
echo "/KBU"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
