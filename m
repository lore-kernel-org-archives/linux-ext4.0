From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: Avoid races caused by on-line resizing and
	SMP memory reordering
Date: Tue, 28 Apr 2009 13:14:45 -0400
Message-ID: <20090428171445.GD24043@mit.edu>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <20090428162359.GK21950@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48229 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZD1ROs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 13:14:48 -0400
Content-Disposition: inline
In-Reply-To: <20090428162359.GK21950@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 06:23:59PM +0200, Jan Kara wrote:
>   Ouch... Hmm, smp_rmb() isn't completely free and mainly it's a bit
> ugly and prone to errors (I'm afraid next time someone changes the
> allocation code, we miss some barriers again)... so.. Maybe a stupid
> idea but wouldn't it be easier to solve the online resize like: freeze
> the filesystem, do all the changes required for extend, unfreeze the
> filesystem?

Eric suggested a helper function when reading from s_groups_count.
That would take care of the code maintenance headache.  One problem
with using freeze/thaw is it won't work without a journal, and we do
support filesystems without journals in ext4.  (Probably the best
solution for netbooks with crapola SSD's.)

As far as smb_rmb() not being free, it's essentially free for
x86/x86_64 platforms.  Is it really that costly on other
architectures?

						- Ted
