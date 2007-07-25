From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: New e2fsprog doc on the ext4 wiki page.
Date: Wed, 25 Jul 2007 19:30:36 +0530
Message-ID: <20070725140036.GA30970@amitarora.in.ibm.com>
References: <20070724110741.65ade06e@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42476 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXGYOAW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jul 2007 10:00:22 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6PE1b7E015611
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 10:01:37 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6PE0L8E417680
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 10:00:22 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6PE0LIW003471
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 10:00:21 -0400
Content-Disposition: inline
In-Reply-To: <20070724110741.65ade06e@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 11:07:41AM -0500, Jose R. Santos wrote:
> Hi folks
> 
> As discussed in the conference call, we are going to create a new doc
> on the ext4 wiki dedicated to track the development of some of the
> features needed in e2fsprogs.  The page will consist of mostly changes
> needed in order to keep e2fsprogs up to date with mainline ext4 kernel
> code.
> 
> I don't plan to add bug fixes, cleanup or trivial changes to the page
> as this would make it hard to keep the page up to date.  The link to
> the page will be:
> 
> http://ext4.wiki.kernel.org/index.php?title=E2fsprogs_features_and_patches&action=edit
> 
> Comments on what you would like to see of this page or in the initial
> list of features I have gather below are welcome. 
:
:
> Extents support:
> - Patches submitted?

Uninitialized extents:
We will need uninitialized extents support for preallocated blocks
(allocated by fallocate()) too.
I can send a patch for this, but I don't think extents support is there
in 1.40.2 release. Is there a place where I can find the latest extents
support patch on top of 1.40 ? I can prepare patch for uninitialized
extents on top of it.

--
Regards,
Amit Arora
