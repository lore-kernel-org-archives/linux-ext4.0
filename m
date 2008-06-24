From: Solofo.Ramangalahy@bull.net
Subject: streaming read and write - test results
Date: Tue, 24 Jun 2008 19:18:45 +0200
Message-ID: <18529.11381.230067.316156@frecb006361.adech.frec.bull.fr>
References: <4278.1214242602@alphaville.zko.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49597 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYFXRSS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 13:18:18 -0400
In-Reply-To: <4278.1214242602@alphaville.zko.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos writes:
 > If you have suggestions for
 > improvements, I'd be very interested in hearing them.
[...]
 > o 8 MSA1000 RAID controllers, each with four back-end SCSI busses, each
 > bus with 7 300GB 15K disks. Only one bus on each controller is used for
 > the tests below (the rest are going to be used for larger filesystem
 > testing). The 7 disks are striped ("horizontally" @ 128KB stripe size) at
 > the hardware level and exported as a single 2TB LUN (that's the current
 > hardware LUN size limit).

You may want to test one LUN without filesystem,
for example with zcav from bonnie++
(http://www.coker.com.au/bonnie++/zcav/).
Then the 8 together.

This way you have some points of comparison (for ext4 as well as other
filesystems) at a lower level.

-- 
solofo


