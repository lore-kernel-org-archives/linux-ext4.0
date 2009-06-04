From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ext4: Add generic writepage callback
Date: Thu, 4 Jun 2009 11:58:44 +0530
Message-ID: <20090604062844.GA26802@skywalker>
References: <1243439888-22680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1243439888-22680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1243439888-22680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090603225308.GA21314@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35371 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbZFDG3E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 02:29:04 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n546T4Go011341
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:29:04 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n546T4vh356630
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:29:04 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n546SsQ9010460
	for <linux-ext4@vger.kernel.org>; Thu, 4 Jun 2009 16:29:04 +1000
Content-Disposition: inline
In-Reply-To: <20090603225308.GA21314@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 03, 2009 at 06:53:08PM -0400, Theodore Tso wrote:
> Hi Aneesh,
> 
> In the future, *please* give me patches versus the patch queue.  This
> patch moves functions around, so applying it is painful in the
> extreme, and it's very painful to check and see whether it undoes
> patches later in the patch.

I have done is against patch queue. After the stable patch. But I guess
some patches you added before the stable cause the patch apply to fail.

I have regenerated the patch and sent -v2 version. Also i split the
coding moving changes in to a new patch 

> 
> In fact, can you redo these patches (2/3 and 3/3), versus the latest
> in the patch queue?
> 

Done. I sent you 4 patches which should be all you need to take.

-aneesh
