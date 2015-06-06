From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Sat, 6 Jun 2015 19:46:14 +0200
Message-ID: <mkvbl6$bdr$1@ger.gmane.org>
References: <mkfbkb$fo1$1@ger.gmane.org> <20150531185934.GE11642@thunk.org>
 <mkg2u2$ckm$1@ger.gmane.org> <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org> <20150605141429.GA26550@thunk.org>
 <mkst24$nbb$1@ger.gmane.org> <20150606003323.GC26550@thunk.org>
 <mku6uc$kb2$1@ger.gmane.org> <20150606154209.GA15306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37301 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbFFRqX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Jun 2015 13:46:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z1IAn-0004F7-Jx
	for linux-ext4@vger.kernel.org; Sat, 06 Jun 2015 19:46:21 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jun 2015 19:46:21 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 06 Jun 2015 19:46:21 +0200
In-Reply-To: <20150606154209.GA15306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 06/06/2015 05:42 PM:
> On Sat, Jun 06, 2015 at 09:19:40AM +0200, U.Mutlu wrote:
>> I posted hello.c (a FUSE demo) in this thread. It is IMO even more secure
>> than the private namespace mount method. The simple reason is:
>> because granting access to the volume (or to a single dir/file)
>> is done inside that user-code itself, ie. the user/owner controls
>> whom he actually gives access.
>> I'm sorry to say this, but this simply proves your last statement above wrong.
>
> So the root user ptraces the FUSE daemon, and it's all she wrote.

Protection against tracing and debugging:
inside the user-application ie. here the FUSE-client,
and also inside the FUSE daemon:

   ptrace(PT_DENY_ATTACH, 0, 0, 0);

Of course one would need to recompile the FUSE daemon.
The company can enforce such a security policy.

And while we are at it, I would add a new option to the FUSE daemon,
so that the client-app can query it before issuing the mount call,
whether it has that protection built in or not, and proceed accordingly...
IMO a solvable problem.


