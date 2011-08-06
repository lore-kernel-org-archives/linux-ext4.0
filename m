From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: Re: [PATCH] ext4: fix message in ext4_remount for rw-remount case
Date: Sat, 06 Aug 2011 21:51:46 +0200
Message-ID: <j1k60i$481$1@dough.gmane.org>
References: <20110801135628.3257a561.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37220 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1HFTzI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Aug 2011 15:55:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Qpmxf-00080s-6n
	for linux-ext4@vger.kernel.org; Sat, 06 Aug 2011 21:55:07 +0200
Received: from h75021.upc-h.chello.nl ([62.194.75.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 06 Aug 2011 21:55:07 +0200
Received: from sfzhi by h75021.upc-h.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 06 Aug 2011 21:55:07 +0200
In-Reply-To: <20110801135628.3257a561.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-08-01 06:56, Toshiyuki Okajima wrote:
> If there are some inodes in orphan list while a filesystem is being
> read-only mounted, we should recommend that pepole umount and then
> mount it when they try to remount with read-write.
On 2011-08-01 06:56, Toshiyuki Okajima wrote:

Hi,

I have just encountered this feature and I have a question:

How do I umount/mount if it's my root filesystem?
Is there anything I can do besides "the Microsoft way" (reboot)?

--
Sergei.

