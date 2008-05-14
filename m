From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Soft lockups in mballoc code
Date: Wed, 14 May 2008 13:45:37 -0400
Message-ID: <27364.1210787137@alphaville.zko.hp.com>
References: <25037.1210612895@alphaville.zko.hp.com>  <1210785517.3657.42.camel@localhost.localdomain>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:34312 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbYENRpj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 13:45:39 -0400
In-Reply-To: Message from Mingming Cao <cmm@us.ibm.com>
   of "Wed, 14 May 2008 10:18:37 PDT." <1210785517.3657.42.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao <cmm@us.ibm.com> wrote:

> On Mon, 2008-05-12 at 13:21 -0400, Nick Dokos wrote:
> > I keep getting soft lockups in mballoc code, running fsstress.
> > I'm running a 2.6.25.2 kernel, with 1.40.8 e2fsprogs. Here
> > is sample console output on a 2-cpu Opteron box with a 2Tb filesystem -
> > the two stack traces keep repeating every minute or so and the only
> > way to get out is to reset the box:
> > 
> Nick, thanks for reporting this. I remember saw soft lockup issue with
> mballoc on 2.6.25-rc kernels.  Could you run the latest 2.6.26-rc2
> kernel? There are lots of bug fixes have been pushed to 2.6.26-rc1.
> Aneesh, do you know if this is a new issue?
> 

Hi Mingming,

I'll do so at the earliest opportunity. In the meantime, I wanted to let
you know that I tried the (stable) 2.6.25.3 kernel on x86-64 and encountered the
same problem, but I also tried it on an IA64 system (again with the
2.6.25.3 kernel) and did *not* encounter the problem. Not sure what this
means yet, but I'll let you know as soon as I get some more information.

Thanks very much,
Nick

