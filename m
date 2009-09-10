From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Thu, 10 Sep 2009 13:33:58 +0530
Message-ID: <20090910080358.GE8690@skywalker.linux.vnet.ibm.com>
References: <4A9E5496.8050909@in.ibm.com>
 <20090902120958.GA16415@mit.edu>
 <4AA66852.8040009@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:36733 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZIJID5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 04:03:57 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8A83wUT004075
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 13:33:58 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8A83wuL2572448
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 13:33:58 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8A83wvG004480
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 18:03:58 +1000
Content-Disposition: inline
In-Reply-To: <4AA66852.8040009@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 08, 2009 at 07:51:06PM +0530, Sachin Sant wrote:
> Theodore Tso wrote:
> >On Wed, Sep 02, 2009 at 04:48:46PM +0530, Sachin Sant wrote:
> >>While executing fsstress against ext4 with 2.6.31-rc8 on a
> >>powerpc box, ran into the following Bug.
> >>
> >>------------[ cut here ]------------
> >>cpu 0x0: Vector: 700 (Program Check) at [c0000000f3ae3970]
> >>   pc: c000000000280f28: .jbd2_journal_commit_transaction+0x8ac/0x1bfc
> >>   lr: c000000000280e58: .jbd2_journal_commit_transaction+0x7dc/0x1bfc
> >>   sp: c0000000f3ae3bf0
> >>  msr: 8000000000029032
> >> current = 0xc0000000f315c7d0
> >> paca    = 0xc000000000b62600
> >>   pid   = 23139, comm = kjournald2
> >>kernel BUG at fs/jbd2/commit.c:533!
> Let me know if there is any thing i could try to help
> find a solution for this problem. After increasing the
> nproc value, i am able to consistently recreate this issue.
> 

Can you confirm that you are able to reproduce it only on powerpc
and not on x86/x86-64 ?

-aneesh
