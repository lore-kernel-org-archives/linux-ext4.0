From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: generic question: user-only directory w/o root access
Date: Mon, 8 Jun 2015 02:12:38 +0200
Message-ID: <ml2mlm$uqs$1@ger.gmane.org>
References: <mkg2u2$ckm$1@ger.gmane.org> <20150604014452.GA5759@thunk.org>
 <alpine.LFD.2.00.1506041323280.32156@localhost.localdomain>
 <mkpjhm$7i5$1@ger.gmane.org> <20150605141429.GA26550@thunk.org>
 <mkst24$nbb$1@ger.gmane.org> <20150606003323.GC26550@thunk.org>
 <mku6uc$kb2$1@ger.gmane.org> <20150606154209.GA15306@thunk.org>
 <mkvbl6$bdr$1@ger.gmane.org> <20150606194843.GB15306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38073 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbbFHAMt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jun 2015 20:12:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z1kgI-0007wV-BH
	for linux-ext4@vger.kernel.org; Mon, 08 Jun 2015 02:12:46 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2015 02:12:46 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2015 02:12:46 +0200
In-Reply-To: <20150606194843.GB15306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 06/06/2015 09:48 PM:
> On Sat, Jun 06, 2015 at 07:46:14PM +0200, U.Mutlu wrote:
>> Theodore Ts'o wrote on 06/06/2015 05:42 PM:
>>> On Sat, Jun 06, 2015 at 09:19:40AM +0200, U.Mutlu wrote:
>>>> I posted hello.c (a FUSE demo) in this thread. It is IMO even more secure
>>>> than the private namespace mount method. The simple reason is:
>>>> because granting access to the volume (or to a single dir/file)
>>>> is done inside that user-code itself, ie. the user/owner controls
>>>> whom he actually gives access.
>>>> I'm sorry to say this, but this simply proves your last statement above wrong.
>>>
>>> So the root user ptraces the FUSE daemon, and it's all she wrote.
>>
>> Protection against tracing and debugging:
>> inside the user-application ie. here the FUSE-client,
>> and also inside the FUSE daemon:
>>
>>    ptrace(PT_DENY_ATTACH, 0, 0, 0);
>>
>> Of course one would need to recompile the FUSE daemon.
>> The company can enforce such a security policy.
>
> And so the root user can install a kernel module which toggles the
> PT_DENY_ATTACH flag for the FUSE daemon after it's started.  Or it
> could use a kprobe or jprobe to dynamically patch the ptrace system
> call to cause it to disregard that flag.  (Or use the ksplice
> funcionality which would make life even easier.)

I could be wrong but I think the DENY_ATTACH is under the control
of the running app itself.
Not sure if any other process can change that on behalf of the app.

>> And while we are at it, I would add a new option to the FUSE daemon,
>> so that the client-app can query it before issuing the mount call,
>> whether it has that protection built in or not, and proceed accordingly...
>> IMO a solvable problem.
>
> And root can cause the kernel to lie to client applications.
>
> Next?

User or his app could check the hash of the kernel file to be sure
it's still the official kernel.



