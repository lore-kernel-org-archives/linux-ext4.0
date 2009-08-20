From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: RFC: guard against more "dangerous" userspace options
Date: Thu, 20 Aug 2009 11:57:30 +0530
Message-ID: <20090820062730.GA23232@skywalker.linux.vnet.ibm.com>
References: <4A81D7EC.2060706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:42935 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZHTG1e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 02:27:34 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp08.in.ibm.com (8.14.3/8.13.1) with ESMTP id n7K6LrtP013599
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 11:51:53 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7K6RXq81114282
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 11:57:33 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n7K6RW3m019239
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2009 16:27:32 +1000
Content-Disposition: inline
In-Reply-To: <4A81D7EC.2060706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2009 at 03:43:24PM -0500, Eric Sandeen wrote:
> I'll keep it short and sweet:
> 
> Can we add a consistent "--eatmydata" type of hurdle to jump over before
> people are allowed to use either the so-far-less-tested tools and/or
> options therein?
> 
> I'm thinking of, so far:
......
> tune2fs -I <bigger>

I have sent patches which should make this better. Any chance to get that reviwed and
applied

-aneesh
