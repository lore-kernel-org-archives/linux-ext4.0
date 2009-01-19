From: Theodore Tso <tytso@mit.edu>
Subject: Re: The meaning of data=ordered as it relates to delayed allocation
Date: Mon, 19 Jan 2009 07:45:13 -0500
Message-ID: <20090119124513.GC7598@mit.edu>
References: <E1LOiN8-0001Cj-91@closure.thunk.org> <20090119044345.GB9482@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56136 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439AbZASMpQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2009 07:45:16 -0500
Content-Disposition: inline
In-Reply-To: <20090119044345.GB9482@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 19, 2009 at 10:13:45AM +0530, Aneesh Kumar K.V wrote:
> > So I wonder if we should either:
> > 
> > (a) make data=ordered force block allocation and writeback --- which
> >     should just be a matter of disabling the
> >     redirty_page_for_writepage() code path in ext4_da_writepage()
> 
> We can't do that because we cannot do block allocation there. So we need
> to redirty the page that have unmapped buffer_heads.

What is preventing us from doing block allocation from
ext4_da_writepage()?

						- Ted
