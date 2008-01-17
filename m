From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Thu, 17 Jan 2008 12:07:16 -0800
Message-ID: <1200600436.4134.35.camel@localhost.localdomain>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr>
	 <1200509307.3985.8.camel@localhost.localdomain>
	 <20080117064736.GA6749@skywalker> <478F234C.90807@bull.net>
	 <20080117120752.GB24979@skywalker> <478F5395.9040203@bull.net>
	 <20080117162928.GC6667@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50768 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbYAQUHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 15:07:14 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0HK7AhT001081
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 15:07:10 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0HK7AIq133554
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 15:07:10 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0HK79Vq025305
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 15:07:10 -0500
In-Reply-To: <20080117162928.GC6667@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-01-17 at 21:59 +0530, Aneesh Kumar K.V wrote:
> On Thu, Jan 17, 2008 at 02:09:41PM +0100, Valerie Clement wrote:
> > Aneesh Kumar K.V wrote:
> >> On Thu, Jan 17, 2008 at 10:43:40AM +0100, Valerie Clement wrote:
> >>> Aneesh Kumar K.V wrote:
> >>>> What about this  ? I guess we will overflow start = start << bsbits;
> >>>>
> >>> Hi Aneesh,
> >>> your patch below doesn't fix the issue, because as start_off is also  
> >>> loff_t, start_off = ac->ac_o_ex.fe_logical << bsbits  also overflows.
> >>>
> >>
> >> loff_t is 64 bits.
> >>
> >> typedef __kernel_loff_t         loff_t;
> >> typedef long long       __kernel_loff_t;
> >> typedef __u32 ext4_lblk_t;
> >> typedef unsigned long long ext4_fsblk_t
> >>
> >> start_off = ac->ac_o_ex.fe_logical << bsbits;
> >>
> >> In the above line what we are storing in start_off is the offset in bytes.So it makes
> >> sense to use the type loff_t. It is neither logical block nor physical block.
> >
> > Oh yes, sorry, you're right. I read too quickly.
> >
> > In fact, it's missing a cast :
> >   start_off = (loff_t) ac->ac_o_ex.fe_logical << bsbits;
> >
> > With that change, the test is ok.
> 
> Updated patch below.
> 
Thanks, folded to the mballoc-core patch

Mingming
> -aneesh
