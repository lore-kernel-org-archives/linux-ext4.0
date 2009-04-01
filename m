From: "Holger Hoffstaette" <holger@wizards.de>
Subject: No ext4 patches in 2.6.29.1?
Date: Wed, 01 Apr 2009 12:40:53 +0200
Message-ID: <pan.2009.04.01.10.40.42.313375@wizards.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47110 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZDAKzH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Apr 2009 06:55:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Loy63-0000m2-5w
	for linux-ext4@vger.kernel.org; Wed, 01 Apr 2009 10:55:03 +0000
Received: from port-87-234-136-15.dynamic.qsc.de ([87.234.136.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Apr 2009 10:55:03 +0000
Received: from holger by port-87-234-136-15.dynamic.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Apr 2009 10:55:03 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

This is not a complaint or bug report. :)
I've been following the recent ext4 activity (purely as an interested user
already running ext4 everywhere) and am somewhat concerned that Chris
Wright's recent announcement of 2.6.29.1 does not seem to contain any ext4
related fixes, like the "brown paper bag" lock typo or others. Is this
just an oversight? I've had no problems with ext4 so far (knock on wood)
but reading about some of the bugs here I'd rather have fixes sooner than
later..release consistency, peace of mind and all that. Is this not how
the stable release process is meant to work?

Thanks for all your hard work.
Holger


