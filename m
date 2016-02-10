From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Wed, 10 Feb 2016 17:33:04 +0000
Message-ID: <bug-111961-13602-qQA4uDRoPX@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49322 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbcBJRdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Feb 2016 12:33:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 79E7920394
	for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2016 17:33:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B77382034F
	for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2016 17:33:04 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

--- Comment #9 from Sebastian <info@dynpages.de> ---
Hi,

just wanted to let you know that I didn't face any error related to ext4 after
disabling acpi for the sata controller.

This was my change (custom powertop settings runner started by systemd):

# Enable SATA link power management for host0   
#echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy';
# Enable SATA link power management for host1   
#echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy';


looks fine so far.


best regards


Sebastian

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
