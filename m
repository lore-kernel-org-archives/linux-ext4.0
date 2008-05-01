From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: start seraching for the right extent from the
	goal group.
Date: Thu, 1 May 2008 21:18:24 +0530
Message-ID: <20080501154824.GB7005@skywalker>
References: <1209554186-6251-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48187EEF.8000101@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:38566 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbYEAPst (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2008 11:48:49 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m41FmOqv015293
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 01:48:24 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41FqlYQ263944
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 01:52:47 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m41Fml6c030809
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 01:48:47 +1000
Content-Disposition: inline
In-Reply-To: <48187EEF.8000101@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2008 at 04:15:11PM +0200, Valerie Clement wrote:
> Aneesh Kumar K.V wrote:
>> With mballoc we search for the best extent using different
>> criteria. We should always use the goal group when we are
>> starting with a new criteria.
>
> Hi Aneesh,
>
> as you are working on the mballoc code, there is another thing
> which is not clear for me: why skipping uninitialized groups in  
> ext4_mb_good_group() when criteria is 0.
> I'm doing tests on large partition (~2TB) and on FS with 1KB
> block size and it impacts the performance when the number of
> groups is great (and the uninit_groups feature is used of course).
> For which reason we skip these groups ?
>

The reason is to avoid initializing block group. We would like to make
sure when we are allocating blocks we allocate them from already
initialized group. Otherwise we would end up initializing multiple block
group with in turn decrease the performance advantage of uninit_group.

The current logic is.

If request len is order of 2 we start with cr=0.

If we are cr=0 skip the uninit block group and search for the right
count of blocks in other initialized block group using simple_scan
logic.

If we don't find the right count of blocks then cr++;

if cr != 0 don't skip uninit block group.

if group is uninit and the request size is order of 2 use the
simple_scan logic which use buddy cache to search for the right count of
block group.

That way we avoid allocating blocks out of uninit group in the first
loop. We allocate blocks only after we looked at all the other
initialized block group.


-aneesh
