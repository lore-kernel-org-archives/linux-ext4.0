From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Tue, 12 May 2009 10:17:19 +0530
Message-ID: <20090512044719.GB6753@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512031756.GK21518@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:34350 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZELEr1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 00:47:27 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4C4lSMh017402
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:47:28 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4C4lRX2417982
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:47:27 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4C4lRru025518
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:47:27 +1000
Content-Disposition: inline
In-Reply-To: <20090512031756.GK21518@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 11:17:56PM -0400, Theodore Tso wrote:
> On Thu, May 07, 2009 at 04:09:28PM +0530, Aneesh Kumar K.V wrote:
> > These buffer_heads are allocated on stack and are
> > used only to make get_blocks calls. So we can set the
> > b_state to 0
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> I've rewritten the commit description to this:
> 
> ext4: Properly initialize the buffer_head state
> 
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> These struct buffer_heads are allocated on the stack (and hence are
> initialized with stack garbage).  They are only used to call a
> get_blocks() function, so that's mostly OK, but b_state must be
> initialized to be 0.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Comments?
> 

good.

-aneesh
