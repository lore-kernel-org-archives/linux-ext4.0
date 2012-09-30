From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH REGRESSION FIX] ext4: fix mtime update in nodelalloc mode
Date: Sun, 30 Sep 2012 15:53:41 -0400
Message-ID: <20120930195341.GC4780@thunk.org>
References: <20120930195124.GF18169@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-nilfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
	stable@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>, Willy Tarreau <w@1wt.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53110 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab2I3Txw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Sep 2012 15:53:52 -0400
Content-Disposition: inline
In-Reply-To: <20120930195124.GF18169@1wt.eu>
 <20120930195002.GA30441@elie.Belkin>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 30, 2012 at 12:50:02PM -0700, Jonathan Nieder wrote:
> Theodore Ts'o wrote:
> 
> > Since __block_page_mkwrite() only has three years,
> > block_page_mkwrite(), ext4_page_mkwrite, and nilfs_page_mkwrite(), the
> 
> years = callers?

Yes, thanks for pointing that out.  I'll fix the commit description.


On Sun, Sep 30, 2012 at 09:51:24PM +0200, Willy Tarreau wrote:
> On Sun, Sep 30, 2012 at 03:48:19PM -0400, Theodore Ts'o wrote:
> > Commits 41c4d25f78c0 and 41c4d25f78c0 introduced a regression
> 
> you mistakenly wrote the same commit ID twice.

Sorry, the two commit ID's are:

5e8830dc85d0 and 41c4d25f78c0

						- Ted
