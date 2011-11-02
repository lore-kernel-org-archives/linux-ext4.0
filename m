From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] jbd/jbd2: validate sb->s_first in
 journal_get_superblock()
Date: Wed, 2 Nov 2011 15:24:30 +0100
Message-ID: <20111102142430.GB31575@quack.suse.cz>
References: <1320113103-27406-1-git-send-email-guaneryu@gmail.com>
 <20111101222955.GE18701@quack.suse.cz>
 <20111101231626.GN32161@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <guaneryu@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1KBOYb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 10:24:31 -0400
Content-Disposition: inline
In-Reply-To: <20111101231626.GN32161@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-11-11 19:16:27, Ted Tso wrote:
> On Tue, Nov 01, 2011 at 11:29:55PM +0100, Jan Kara wrote:
> >   Thanks. I've fixed-up the style problems pointed out by Andreas and added
> > the patch to my tree.
> 
> Oops, I grabbed it too.  How do you want to resolve this?  I can just
> carry the jbd2 change, or I can carry both, or I can let you carry
> both.  Either is fine with me.  (And if we both carry it git should do
> the right thing anyway.  :-)
  OK, carry it, I'll remove the patch from my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
