From: Ankur Tank <Ankur.Tank@LntTechservices.com>
Subject: [ext4] How to simulate aborted journal error
Date: Tue, 19 Jul 2016 16:17:46 +0000
Message-ID: <f04dc82eca5849cb999e5d28d1694a1a@POCITMSXMB04.LntUniverse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "artfri2@gmail.com" <artfri2@gmail.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([203.199.60.171]:48998 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbcGSQ2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2016 12:28:19 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Experts,

We are using BeagleBoneBlack based custom board,

During firmware upgrade testing I got following errors

[  194.912834] EXT4-fs error (device mmcblk0p15): ext4_journal_check_start:56: Detected aborted journal
[  194.922558] EXT4-fs (mmcblk0p15): Remounting filesystem read-only

Rebooting the board recovered this error but for testing I want to simulate this error and then in my upgrade scripts I want to handle that error case.
is there a way to simulate above error ?

Thank you,

Regards,
Ankur

L&T Technology Services Ltd

www.LntTechservices.com<http://www.lnttechservices.com/>

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
