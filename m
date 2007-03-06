From: Daniel Drake <ddrake@brontes3d.com>
Subject: Re: e2fsck and human intervention
Date: Tue, 06 Mar 2007 09:27:07 -0500
Message-ID: <1173191227.11804.9.camel@systems03.mmm.com>
References: <1173112017.6300.14.camel@systems03.mmm.com>
	 <20070306024024.GZ6662@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp126.iad.emailsrvr.com ([207.97.245.126]:37530 "EHLO
	smtp126.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060AbXCFO1J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2007 09:27:09 -0500
In-Reply-To: <20070306024024.GZ6662@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-03-06 at 10:40 +0800, Andreas Dilger wrote:
> As Ted said, if e2fsck detects anything wrong then this IS corruption
> of some kind.  It might indicate that your disks are writing with
> cache enabled and losing some writes that had been reported to the
> kernel as committed to disk.

Entirely possible, I'll look into that. Thanks for the pointer.

> > Are there any better approaches than something like the following?
> > 
> > 1. Run "e2fsck -p /"
> > 
> > 2. If bit 3 is set in exit code (i.e. preen functionality detected
> > unexpected inconsistency) then run "e2fsck -y /"
> 
> This is no better than just running "e2fsck -y" in the first place,
> just twice as slow.

OK. Given that write caching may be required for performance reasons or
there might be other possible reasons which would result in
preen-unrepairable fs corruption on power loss, my question is now: Is
it a really bad idea to run "e2fsck -y" on every boot?

I'm not expecting magic: I realise that in such configurations there is
risk of data loss. However, every time I have seen preen fail so far,
running "e2fsck -y" gets things back into bootable state and I'm simply
wondering how much potential trouble I would be getting myself into by
automating this.

Thanks.
-- 
Daniel Drake
Brontes Technologies, A 3M Company
