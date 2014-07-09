From: Grzegorz Sikorski <g.sikorski@kelvatek.com>
Subject: Question about data integrity on SD cards
Date: Wed, 09 Jul 2014 13:17:25 +0100
Message-ID: <53BD32D5.3000804@kelvatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outbound-jr2.exchangedefender.com ([65.99.255.229]:55439 "EHLO
	outbound-jr2.exchangedefender.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146AbaGIMZO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 08:25:14 -0400
Received: from kelvatek.com (78-33-179-130.static.enta.net [78.33.179.130])
	by outbound-jr2.exchangedefender.com (8.13.8/8.13.8) with ESMTP id s69CHHv3024052
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jul 2014 08:17:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

In our project we use SQLite3 database on EXT4 filesystem partition on 
microSD card. On unexpected power failure/system crash or just hardware 
reset, we observe occasional database corruption. SQLite3 developers 
claim their part is free of risk of database corruption, as long as 
fsync call is doing it's job properly. We tried several SD cards, 
including industrial grade which should have proper firmware (at least 
their manufacturers say there is no risk of data corruption on power 
loss). We tried several different mount settings and after some reading 
we found, that the safest (and slowest) option (that should never fail, 
as far as we understand) would be like:
rw,relatime,barrier=1,journal_checksum,nodelalloc,data=journal,usrquota
In spite of all that, we still observe random database corruption on 
power-down/reset. Can you confirm there is no problem in EXT4 filesystem?

Best regards,
Greg

--
ExchangeDefender Message Security: Click below to verify authenticity
https://admin.exchangedefender.com/verify.php?id=s69CHHv3024052&from=g.sikorski@camlintechnologies.com


