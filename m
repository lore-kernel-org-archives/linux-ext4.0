From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix oops in mballoc caused by a variable overflow
Date: Thu, 17 Jan 2008 17:37:52 +0530
Message-ID: <20080117120752.GB24979@skywalker>
References: <1200510717.4561.11.camel@ext1.frec.bull.fr> <1200509307.3985.8.camel@localhost.localdomain> <20080117064736.GA6749@skywalker> <478F234C.90807@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59993 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYAQMHz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 07:07:55 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m0HC7Onx011332
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 23:07:24 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0HCBUoC137440
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 23:11:30 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0HC7rLV023395
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2008 23:07:53 +1100
Content-Disposition: inline
In-Reply-To: <478F234C.90807@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 17, 2008 at 10:43:40AM +0100, Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>> What about this  ? I guess we will overflow start = start << bsbits;
>>
>
> Hi Aneesh,
> your patch below doesn't fix the issue, because as start_off is also  
> loff_t, start_off = ac->ac_o_ex.fe_logical << bsbits  also overflows.
>

loff_t is 64 bits.

typedef __kernel_loff_t         loff_t;
typedef long long       __kernel_loff_t;
typedef __u32 ext4_lblk_t;
typedef unsigned long long ext4_fsblk_t

start_off = ac->ac_o_ex.fe_logical << bsbits;

In the above line what we are storing in start_off is the offset in bytes.So it makes
sense to use the type loff_t. It is neither logical block nor physical block.


-aneesh
