From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Running fsck of huge ext4 partition takes weeks
Date: Tue, 25 Aug 2015 18:30:34 +0300
Message-ID: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34646 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbbHYPbO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2015 11:31:14 -0400
Received: by obbfr1 with SMTP id fr1so144877194obb.1
        for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2015 08:31:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Recently I had to run fsck on 47TB ext4 partition backed by hardware
RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
100% of single CPU. It detected errors (and fixed them) but doesn't
finish yet.

Rescue disc is based on Debian 7.8.
kernel: 4.1.4-5
e2fsprogs: 1.42.5-1.1+deb7u1

Any suggestions?

Regards,
Alexander Afonyashin
