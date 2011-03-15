From: Sven <hartrumpf@gmx.net>
Subject: Re: =?utf-8?b?ZXh0NF9hbGxvY19jb250ZXh0?= occupies 150 GiB of memory and makes the system unusable
Date: Tue, 15 Mar 2011 10:41:06 +0000 (UTC)
Message-ID: <loom.20110315T113622-714@post.gmane.org>
References: <201011221323.25342.bartoschek@or.uni-bonn.de> <4CEA8B4A.3030608@redhat.com> <201011221637.58275.bartoschek@or.uni-bonn.de> <4CEA902F.9040706@redhat.com> <20101205031130.GA4273@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37866 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1COKzJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 06:55:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1PzRu6-00005L-Cd
	for linux-ext4@vger.kernel.org; Tue, 15 Mar 2011 11:55:06 +0100
Received: from business-092-079-182-151.static.arcor-ip.net ([92.79.182.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 11:55:06 +0100
Received: from hartrumpf by business-092-079-182-151.static.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 11:55:06 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o writes:

> Christoph,
> 
> Have you been able to replicate this problem since rebooting your
> machine.  I've never seen anything quite like your report before.

I have a similar problem here: 2.5 GB of 6 GB used by ext4_allocation_context
according to slabtop.

# uname -a
Linux ... 2.6.34.7-0.7-default #1 SMP 2010-12-13 11:13:53 +0100 x86_64 x86_64
x86_64 GNU/Linux

openSUSE 11.3

> If you do, a couple of questions.  Which slab allocator are you using?
> Are you using SLAB or SLUB?  (grep for CONFIG_SLAB or CONFIG_SLUB in
> your .config file).

It seems to be SLAB, so I cannot use slabinfo:
# slabinfo -r
SYSFS support for SLUB not active

Any solutions found in the past 3 months? 


