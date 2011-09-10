From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Sat, 10 Sep 2011 22:24:09 +0200
Message-ID: <20110910202409.GB6709@quack.suse.cz>
References: <1313780769-21713-1-git-send-email-adityakali@google.com>
 <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
 <20110829204602.GI5672@quack.suse.cz>
 <20110909154057.GA7738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	Aditya Kali <adityakali@google.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1IJUYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Sep 2011 16:24:12 -0400
Content-Disposition: inline
In-Reply-To: <20110909154057.GA7738@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 09-09-11 11:40:57, Christoph Hellwig wrote:
> On Mon, Aug 29, 2011 at 10:46:02PM +0200, Jan Kara wrote:
> > The only pain point is repquota(8) - that needs a new kernel interface to
> > work reliably (for ocfs2 and xfs we workaround the inability to iterate
> > over all quota structures from userspace by using getpwent but that's just
> > ugly).
> 
> Feel free to a new quotactl case to support it, but I don't reall see
> the problem of the getpwent loop.
  Well, the trouble is with systems which have accounts stored e.g. in
LDAP with thousands / tens thousands of users (although each machine is
used only by a small subset of users). Then iterating with getpwent gets
really inefficient...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
