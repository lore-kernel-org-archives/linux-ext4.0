From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: write/write/fallocate quota leakage
Date: Fri, 04 Jun 2010 14:33:06 +0530
Message-ID: <87ljavtbjp.fsf@linux.vnet.ibm.com>
References: <87typk1q8i.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41335 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0FDJDN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jun 2010 05:03:13 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp07.in.ibm.com (8.14.4/8.13.1) with ESMTP id o54938iQ031151
	for <linux-ext4@vger.kernel.org>; Fri, 4 Jun 2010 14:33:08 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o54937RJ3268646
	for <linux-ext4@vger.kernel.org>; Fri, 4 Jun 2010 14:33:07 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5493739028018
	for <linux-ext4@vger.kernel.org>; Fri, 4 Jun 2010 19:03:07 +1000
In-Reply-To: <87typk1q8i.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 03 Jun 2010 12:21:01 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Recently one "write vs fallocate" quota leakage was fixed, but
> not completely. It is still possible if uninitialized extent which
> covers several delay allocated regions converted to initialized one.
> 
> Take a look at test-case attached.
> The issue is clear enough, but I don't have a good solution for now.
> Off course we can add one more restriction to zeroout logic, but this is
> unproductive way because we have to keep zeroout logic simple as possible.
> 
> Aneesh, do you have any sound ideas?
> 

I will have to look at this more closer. Will get back to you.

-aneesh
