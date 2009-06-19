From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Some 64-bit tests
Date: Fri, 19 Jun 2009 17:04:28 +0530
Message-ID: <20090619113428.GD17784@skywalker>
References: <18887.1244469441@gamaville.dokosmarshall.org> <20090608201037.GB23723@skywalker> <14597.1244517228@gamaville.dokosmarshall.org> <20090610181320.GA6953@mit.edu> <20090611055006.GA8073@skywalker> <20090618211112.GE7183@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:47846 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZFSLei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jun 2009 07:34:38 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5JLYbYf012351
	for <linux-ext4@vger.kernel.org>; Sat, 20 Jun 2009 07:34:37 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5JBYcP1844024
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2009 21:34:38 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5JBYbw2030148
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2009 21:34:37 +1000
Content-Disposition: inline
In-Reply-To: <20090618211112.GE7183@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 18, 2009 at 05:11:12PM -0400, Theodore Tso wrote:
> On Thu, Jun 11, 2009 at 11:20:06AM +0530, Aneesh Kumar K.V wrote:
> > 
> > I already have a RFC patch which Nick actually tested. It is giving 32MB
> > extents, which is expected because the max order in buddy cache is
> > blocksize_bits + 1. I have a Fixme in there regarding scaling the start
> > block which was hoping to fix soon.
> 
> FYI, this patch seems to cause the system to lock up on umount when
> running xfstests #135.
> 
> I'm removing it from the unstable patch queue for now; do you have an
> update for this patch?

I haven't got time to work on the changes needed. Will check what is
causing the system lockup

-aneesh
