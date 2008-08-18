From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] use percpu data for lg_prealloc_list
Date: Mon, 18 Aug 2008 21:26:50 +0530
Message-ID: <20080818155650.GA6491@skywalker>
References: <48A331FA.6070602@redhat.com> <48A9999C.6070609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:43917 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752396AbYHRP46 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 11:56:58 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7IFutHj007034
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 21:26:55 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7IFutNw1511494
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 21:26:55 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7IFutM0008222
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 21:26:55 +0530
Content-Disposition: inline
In-Reply-To: <48A9999C.6070609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2008 at 10:47:40AM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > lg_prealloc_list seems to cry out for a per-cpu data structure; on a large
> > smp system I think this should be better.  I've lightly tested this change
> > on a 4-cpu system.  Comments welcome...
> 
> Any thoughts on this?  Does this seem to be the right way to go?
> 

Acked-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
