From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: fsck ate my ext4 home partition, help!?
Date: Wed, 6 May 2009 21:01:19 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0905062059280.8935@bogon.housecafe.de>
References: <20090504131128.135100@gmx.net> <alpine.DEB.2.01.0905042222260.6162@bogon.housecafe.de> <20090505144436.125410@gmx.net> <alpine.DEB.2.01.0905051337140.6162@bogon.housecafe.de> <20090506134315.185580@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Marcel Partap <mpartap@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZEGEBV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2009 00:01:21 -0400
In-Reply-To: <20090506134315.185580@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 6 May 2009, Marcel Partap wrote:
> Oh and this extundelete tool - i couldn't quite put it
> to the test because as soon as i let it loose on the partition - well it 
> quickly eats up all memory causing the oom_killer to terminate it.

There are more "undelete" tools listed in the wiki: 
http://ext4.wiki.kernel.org/index.php/Undeletion

...but the results may not be perfect, to say the least.

Christian.
-- 
Bruce Schneier doesn't keep secrets -- they keep themselves out of fear.
