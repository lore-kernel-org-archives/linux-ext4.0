From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Mon, 23 May 2011 15:21:58 +0200
Message-ID: <20110523132158.GB4716@quack.suse.cz>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <20110518180022.GM18929@tux1.beaverton.ibm.com>
 <20110519105708.GD8417@quack.suse.cz>
 <20110520175953.GE29282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@us.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab1EWNWC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 09:22:02 -0400
Content-Disposition: inline
In-Reply-To: <20110520175953.GE29282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 20-05-11 13:59:53, Ted Tso wrote:
> On Thu, May 19, 2011 at 12:57:08PM +0200, Jan Kara wrote:
> >   Since Ted has merged your stable pages patches touching ext4, I'll rebase
> > my ext4 patch on top of that. Regarding block_page_mkwrite() I will add
> > that one-liner to the series (because the ext4_page_mkwrite() now depends
> > on that).
  Hi Ted,

> Does your 3/3 ext4 patch have dependencies on your 1/3 and 2/3
> VFS-layer patches?
  Yes, it does depend on the new helper introduced in 1/3. Should I push
3/3 via Al as well or just wait with it until Al merges the first two
patches and then push it to you?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
