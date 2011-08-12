From: Benjamin Peterson <benjamin@python.org>
Subject: Re: Ext4 allocation strategy
Date: Fri, 12 Aug 2011 22:18:19 +0000 (UTC)
Message-ID: <loom.20110813T001740-521@post.gmane.org>
References: <4E452ED4.9000307@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33525 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1HLWZM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Aug 2011 18:25:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Qs0A8-0000IM-KG
	for linux-ext4@vger.kernel.org; Sat, 13 Aug 2011 00:25:08 +0200
Received: from 64-131-13-109.usfamily.net ([64.131.13.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 13 Aug 2011 00:25:08 +0200
Received: from benjamin by 64-131-13-109.usfamily.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 13 Aug 2011 00:25:08 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

torn5 <torn5 <at> shiftmail.org> writes:
> 
> So can you tell me something?

You might find the comments in fs/ext4/mballoc.c helpful.




