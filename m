From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Mon, 9 May 2011 09:55:16 -0400
Message-ID: <20110509135516.GJ4138@thunk.org>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
 <20110509110329.GF4122@quack.suse.cz>
 <BANLkTi=hSeN4mb8x9vu4DfBb-us_ocaqXw@mail.gmail.com>
 <20110509113052.GI4122@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37188 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1EINz0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 09:55:26 -0400
Content-Disposition: inline
In-Reply-To: <20110509113052.GI4122@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 09, 2011 at 01:30:52PM +0200, Jan Kara wrote:
> Ah, I see. But then you just reintroduced the bug I was trying to fix. So
> either do_split() has to do the marking of buffer dirty, or we have to do
> it before calllig do_split(), or do_split() has to be changed and not
> release passed buffer (and the two callers have to do it - which they seem
> to do anyway). I don't mind either way but your fix is wrong.

I think it's OK.  We do call ext4_handle_dirty_metadata on frame->bh,
which deals with the original version of bh.  And the cases where
do_split() sets bh to NULL is either (a) a journal error, in which
case we will have already aborted the journal, or an I/O error while
reading in the block, so bh won't have gotten modified yet.

Is there a case that you're worried about that I'm missing?

   	   	     	    	    	       - Ted
