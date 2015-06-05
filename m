From: Syed Imtiaz <sihussain2@gmail.com>
Subject: Re: Is ext2 freezable?
Date: Fri, 5 Jun 2015 11:23:58 +0000 (UTC)
Message-ID: <loom.20150605T132316-300@post.gmane.org>
References: <EE124450C0AAF944A40DD71E61F878C99CE2C3@SINEX14MBXC418.southpacific.corp.microsoft.com> <20140918191736.GC19520@thunk.org> <EE124450C0AAF944A40DD71E61F878C99D4840@SINEX14MBXC418.southpacific.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56360 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969AbbFEOfV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2015 10:35:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z0si9-000592-AE
	for linux-ext4@vger.kernel.org; Fri, 05 Jun 2015 16:35:05 +0200
Received: from 125.16.138.141 ([125.16.138.141])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jun 2015 16:35:05 +0200
Received: from sihussain2 by 125.16.138.141 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 05 Jun 2015 16:35:05 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dexuan Cui <decui <at> microsoft.com> writes:
> Hi Ted,
> Thanks very much for the clarification!
> 
> And thanks a lot for implementing this -- I've seen the patches you 
sent out
> several hours ago.
> 
> IMO it's useful to have such compatibility, e.g.,
> Hyper-V guest has a fsfreeze-based feature to back up the data; the 
feature
> works fine for ext4 partition, but Ubuntu's installer can create /boot
> of ext2 partition by default and hence the feature can't work:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362574
> 
> I believe the bug will go away after Ubuntu integrates your patches.
> 
> Thanks!


Hi Theodore,
  CAn you please tell me where can i find these patches. I am unable to 
locate it. or the steps the install it ?
Do we have to install it every system that doesnt support fsfreeze in 
the ext2 fs.

Your help will be deeply appreciated

thanks in advance



