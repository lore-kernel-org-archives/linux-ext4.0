From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Sat, 6 Jun 2015 09:19:40 +0200
Message-ID: <mku6uc$kb2$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org> <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org> <20150605141429.GA26550@thunk.org>
 <mkst24$nbb$1@ger.gmane.org> <20150606003323.GC26550@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44787 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbbFFHTs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Jun 2015 03:19:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z18OQ-0002q3-E3
	for linux-ext4@vger.kernel.org; Sat, 06 Jun 2015 09:19:46 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jun 2015 09:19:46 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jun 2015 09:19:46 +0200
In-Reply-To: <20150606003323.GC26550@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 06/06/2015 02:33 AM:
> On Fri, Jun 05, 2015 at 09:24:51PM +0200, U.Mutlu wrote:
>> I think the filesystem could indeed implement such a "user-only" directory,
>> because the FUSE-API wrapper showed me that it is indeed possible
>> to implement that idea. I would suggest to add this feature to ext4,
>> and that new feature could be a real game-changer (yes, I know another
>> bold statement) in IT security.
>
> Sorry, I'm not willing to advertise that a file system has a feature
> which is a pure snake oil --- someone claiming that this can be done
> is making a fradulently untrue statement.
>
> Regards,
>
> 						- Ted

I posted hello.c (a FUSE demo) in this thread. It is IMO even more secure
than the private namespace mount method. The simple reason is:
because granting access to the volume (or to a single dir/file)
is done inside that user-code itself, ie. the user/owner controls
whom he actually gives access.
I'm sorry to say this, but this simply proves your last statement above wrong.

Thx for this interessting discussion and exchange of ideas on security
Uenal


