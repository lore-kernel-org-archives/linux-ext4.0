From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Linux unshare -m for per-process private filesystem mount points
Date: Mon, 1 Jun 2015 03:39:45 +0200
Message-ID: <mkgd52$qlg$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org> <mkg4kf$429$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58006 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbbFABjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 31 May 2015 21:39:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YzEhk-0007QI-03
	for linux-ext4@vger.kernel.org; Mon, 01 Jun 2015 03:39:52 +0200
Received: from ip4d14aa5f.dynamic.kabel-deutschland.de ([77.20.170.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 03:39:51 +0200
Received: from for-gmane by ip4d14aa5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 03:39:51 +0200
In-Reply-To: <mkg4kf$429$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I just found a cool linux feature which helps me to create private mounts
where no other user or process can see or access it:
by using linux namespaces with the tool "unshare" from the pkg linux-utils.

It allows, besides other things, per-process private filesystem mount points.
It also works with truecrypt-mounts.

Here's a good basic demo of the idea:
http://blog.endpoint.com/2012/01/linux-unshare-m-for-per-process-private.html

See also: man unshare, man 2 unshare

-- 
cu
Uenal


