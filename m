From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during
	block allocation failure
Date: Fri, 5 Jun 2009 00:31:17 -0400
Message-ID: <20090605043117.GB4046@mit.edu>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090405031116.GG7553@mit.edu> <20090406100509.GB31189@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39125 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZFEEbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 00:31:23 -0400
Content-Disposition: inline
In-Reply-To: <20090406100509.GB31189@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 06, 2009 at 12:05:09PM +0200, Jan Kara wrote:
> > I think this can be fixed by making sure that ext4_truncate() and
> > ext4_ext_truncate() calls ext4_orphan_del() in *all* of their error
> > paths.  That *should* the problem, since at the moment, it doesn't
> > look vmtruncate() will return without calling inode->i_op->truncate().
> > But could you double check this carefully?
>
>   Ah, OK, that should be fixed. But note that current ext4_setattr()
> does exactly the same thing on standard truncates - it adds inode to
> orphan list and calls inode_setattr() which end's up calling vmtruncate().

I finally had a chance to take a closer look at this.  ext4_setattr()
is safe, because it does this after calling inode_setattr():

	/* If inode_setattr's call to ext4_truncate failed to get a
	 * transaction handle at all, we need to clean up the in-core
	 * orphan list manually. */
	if (inode->i_nlink)
		ext4_orphan_del(NULL, inode);

So if we put the same thing into the ext4_write_begin() and
ext4_writeback_write_end() in these patches, it should be OK.  The key
is that if the inode is already is on the orphan list, it's harmless
to call ext4_orphan_add() --- and if the inode has already been
removed from the orphan list, it's harmless to call ext4_orphan_del()
on it.

					- Ted
