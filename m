From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] vfs: Add BUG_ON for delayed and unwritten
	extentsin submit_bh
Date: Tue, 12 May 2009 10:22:10 +0530
Message-ID: <20090512045210.GC6753@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512031709.GJ21518@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42013 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZELEwV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 00:52:21 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4C4qExv005430
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:52:14 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4C4qMi2192894
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:52:22 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4C4qLGV004456
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:52:21 +1000
Content-Disposition: inline
In-Reply-To: <20090512031709.GJ21518@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 11:17:09PM -0400, Theodore Tso wrote:
> On Thu, May 07, 2009 at 04:09:30PM +0530, Aneesh Kumar K.V wrote:
> > We should not do submit_bh for delayed and unwritten extents. So
> > add a BUG_ON on them.
> 
> Hmm, maybe we should add a BUG_ON(buffer_new(bh)) here to?  That flag
> should never leak out to submit_bh as well, right?
> 

Yes . But since BH_New is used by all the filesystems we need to
verify them and make sure other filesystems gets it right. IIUC BH_Delay and
BH_Unwritten are only used by ext4, xfs and btrfs

-aneesh
