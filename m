From: Theodore Tso <tytso@mit.edu>
Subject: Re: a question for i_inode's i_size in ext2
Date: Sat, 20 Sep 2008 02:35:02 -0400
Message-ID: <20080920063502.GB12762@mit.edu>
References: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com> <20080920032522.GB9633@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?7ZmN7Iug?= shin hong <hongshin@gmail.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36072 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750891AbYITGfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 02:35:09 -0400
Content-Disposition: inline
In-Reply-To: <20080920032522.GB9633@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 20, 2008 at 05:25:22AM +0200, Jan Kara wrote:
> Reading i_size is a different matter - see
> i_size_read function. We use seqlock for that - essentially we use an
> atomic counter which is incremented on every change of i_size and check
> that it's value before we started reading i_size and after we have
> finished reading it has not changed. I hope this helps.

Just to clarify for Shin Hong's benefit: this is necessary only on SMP
(or CONFIG_PREEMPT) 32-bit platforms in order to make sure we read a
coherent 64-bit i_size value.

						- Ted
