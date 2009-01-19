From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: The meaning of data=ordered as it relates to delayed allocation
Date: Mon, 19 Jan 2009 20:15:54 +0530
Message-ID: <20090119144554.GJ9482@skywalker>
References: <E1LOiN8-0001Cj-91@closure.thunk.org> <20090119044345.GB9482@skywalker> <20090119124513.GC7598@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:36859 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZASOqE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 09:46:04 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id n0JEk1vM001089
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 20:16:01 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0JEi5U94395080
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 20:14:05 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id n0JEk19p028762
	for <linux-ext4@vger.kernel.org>; Tue, 20 Jan 2009 01:46:01 +1100
Content-Disposition: inline
In-Reply-To: <20090119124513.GC7598@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 19, 2009 at 07:45:13AM -0500, Theodore Tso wrote:
> On Mon, Jan 19, 2009 at 10:13:45AM +0530, Aneesh Kumar K.V wrote:
> > > So I wonder if we should either:
> > > 
> > > (a) make data=ordered force block allocation and writeback --- which
> > >     should just be a matter of disabling the
> > >     redirty_page_for_writepage() code path in ext4_da_writepage()
> > 
> > We can't do that because we cannot do block allocation there. So we need
> > to redirty the page that have unmapped buffer_heads.
> 
> What is preventing us from doing block allocation from
> ext4_da_writepage()?
> 

The callback is called with page lock held and we can't start a journal
with page lock held.

-aneesh
