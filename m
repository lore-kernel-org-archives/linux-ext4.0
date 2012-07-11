From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHv6 3/5] ext4: remove unnecessary superblock dirtying
Date: Wed, 11 Jul 2012 12:11:50 +0200
Message-ID: <20120711101150.GH1316@quack.suse.cz>
References: <1342000698-13556-1-git-send-email-dedekind1@gmail.com>
 <1342000698-13556-4-git-send-email-dedekind1@gmail.com>
 <20120711100726.GE1316@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab2GKKLv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 06:11:51 -0400
Content-Disposition: inline
In-Reply-To: <20120711100726.GE1316@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-07-12 12:07:26, Jan Kara wrote:
> On Wed 11-07-12 12:58:16, Artem Bityutskiy wrote:
...
> > And this is the behavior this patch modifies: we stop using 's_dirt' and just
> > mark the superblock buffer as dirty right away. Indeed:
> > 
> > 1. It does not add any value to delay the I/O submission for cases 1-3 above.
> >    They are rare.
> > 2. Case number 4 above depends on whether we have file-system checksumming
> >    enabled or disables.
> >    a) If it is disabled (most common scenario), then it is all-right to just
> >       mark the superblock buffer as dirty right away and it should affect
> >       performance.
> >    b) If it is enabled, then we'll end up doing a bit more work on deletion
> >       because we'll re-calculate superblock checksum every time.
> > 
> > So case 2.b is a bit controversial, but I think it is acceptable. After all, by
> > enabling checksumming we already sign up for paying the price of calculating
> > it. The way to improve checksumming performance globally would be to calculate
> > it just before sending buffers to the I/O queue. We'd need some kind of
> > call-back which could be registered by file-systems.
  Actually, the most common case of adding orphan inode used
ext4_handle_dirty_super_now() so for that case there is no difference. And
other cases are so rare it really does not matter... So there shouldn't be
any measurable difference.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
