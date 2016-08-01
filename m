From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: xattr index for hurd
Date: Mon, 1 Aug 2016 09:03:35 -0400
Message-ID: <20160801130335.GG12853@thunk.org>
References: <a3ef36c5-cd3b-5fc2-e9fc-eb7e823f0510@outlook.com>
 <BLU175-W270CF93954CBCB94CA36CC9360@phx.gbl>
 <20160801034228.GE12853@thunk.org>
 <20160801060453.GA32095@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LastAvengers <lastavengers@outlook.com>, Jan Kara <jack@suse.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34650 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbcHANE0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2016 09:04:26 -0400
Content-Disposition: inline
In-Reply-To: <20160801060453.GA32095@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 31, 2016 at 11:04:53PM -0700, Christoph Hellwig wrote:
> Note thast _iff_ you ever want to expose the hurd xattrs under Linux
> (or in fact at all - gnu.* is only fine for purely internal usage)
> please use the system namespace.  We really shouldn't expose more than
> the existing namespaces to userspace.

Hmm, good point.  If you're not going to expose it at all, then the
system namespace works fine.  One potential concern with that plan is
that we don't have a way of coordinating *use* of the system namespace
across Linux and Hurd, though.  We may need to come up with some kind
of convention for that purpose.  Note that for space reasons, there's
no need to make the ascii string used in the system namespace to be
long.  So something like GNUt and GNUa for the translator and author
fields is better from the reducing the space used for the xattrs
(which is important if you are using a 256 byte inode and want to keep
the xattr inside the inode table).

							- Ted
