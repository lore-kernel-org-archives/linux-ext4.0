From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs : Fix the return values for ino=0 in
	ext2fs_read_inode_full() if inode cache has been flushed.
Date: Sat, 19 Jul 2008 10:49:06 -0400
Message-ID: <20080719144906.GA8165@mit.edu>
References: <ea11fea30807120657l2de0b501qefb45231edd5fac0@mail.gmail.com> <ea11fea30807142210w1dbc8f6aq59d3a295ab31a653@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48291 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753981AbYGSOtM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Jul 2008 10:49:12 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30807142210w1dbc8f6aq59d3a295ab31a653@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 15, 2008 at 10:40:22AM +0530, Manish Katiyar wrote:
> Any ack/nack on this ?

Applied, sorry for forgetting to ack it.

						- Ted
