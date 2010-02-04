From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ext4: Do not allow retry alloc loop under open
 transaction
Date: Thu, 04 Feb 2010 17:07:21 +0530
Message-ID: <87wrytqlji.fsf@linux.vnet.ibm.com>
References: <874olytbpe.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56609 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab0BDLh2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 06:37:28 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp09.in.ibm.com (8.14.3/8.13.1) with ESMTP id o14B2g7O016822
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 16:32:42 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o14BbO9A2277418
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 17:07:24 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o14BbNhX009484
	for <linux-ext4@vger.kernel.org>; Thu, 4 Feb 2010 22:37:24 +1100
In-Reply-To: <874olytbpe.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 03 Feb 2010 21:27:31 +0300, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> 
> Some times we call ->write_begin() with opened journal
> but write_begin() may internally call ext4_should_retry_alloc()
> in case of ENOSPC, which result in deadlock.
> This patch introduce new AOP_FLAG which should be tested on retry
> alloc path.
> 

Can you explain this further. We do a journal_stop before
ext4_should_retry_alloc. So not sure about the deadlock.

-aneesh
