From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: The meaning of data=ordered as it relates to delayed allocation
Date: Mon, 19 Jan 2009 10:13:45 +0530
Message-ID: <20090119044345.GB9482@skywalker>
References: <E1LOiN8-0001Cj-91@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:45536 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZASEn5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Jan 2009 23:43:57 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n0J4geHq005885
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 15:42:40 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0J4htYB295738
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 15:43:55 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0J4hsKt022726
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 15:43:54 +1100
Content-Disposition: inline
In-Reply-To: <E1LOiN8-0001Cj-91@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 18, 2009 at 07:52:10PM -0500, Theodore Ts'o wrote:
> 
> An Ubuntu user recently complained about a large number of recently
> updated files which were zero-length after an crash.  I started looking
> more closely at that, and it's because we have an interesting
> interpretation of data=ordered.  It applies for blocks which are already
> allocated, but not for blocks which haven't been allocated yet.  This
> can be surprising for users; and indeed, for many workloads where you
> aren't using berk_db some other database, all of the files written will 
> be newly created files (or files which are getting rewritten after
> opening with O_TRUNC), so there won't be any difference between
> data=writeback and data=ordered.


That meaning of data=ordered is to ensure that we don't update inode
i_size without writing the data blocks within i_size. So even with
delayed allocation if we have i_size update ( this happen when we
allocate blocks ) we would write the data blocks first.

With that interpretation having a zero block file on crash is fine. But
we should not find the files corrupted.(ie, files with wrong contents).

> 
> So I wonder if we should either:
> 
> (a) make data=ordered force block allocation and writeback --- which
>     should just be a matter of disabling the
>     redirty_page_for_writepage() code path in ext4_da_writepage()


We can't do that because we cannot do block allocation there. So we need
to redirty the page that have unmapped buffer_heads.

> 
> (b) add a new mount option, call it data=delalloc-ordered which is (a)
> 
> (c) change the default mount option to be data=writeback


This won't guarantee that i_size/metadata get updated ONLY after data blocks
are written.

> 
> (d) Do (b) and make it the default
> 
> (e) Keep things the way they are
> 
> Thoughts, comments?   My personal favorite is (b).   This allows users
> who want something that works functionally much more like ext3 to get
> that, while giving us the current speed advantages of a more aggressive
> delayed allocation.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
