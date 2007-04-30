From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext2/3 block remapping tool
Date: Mon, 30 Apr 2007 08:09:30 -0400
Message-ID: <20070430120930.GA10604@thunk.org>
References: <20070426192953.GC2841@duck.suse.cz> <20070427180942.GB5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58554 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423182AbXD3MJi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 08:09:38 -0400
Content-Disposition: inline
In-Reply-To: <20070427180942.GB5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 27, 2007 at 12:09:42PM -0600, Andreas Dilger wrote:
> I'd prefer that such functionality be integrated with Takashi's online
> defrag tool, since it needs virtually the same functionality.  For that
> matter, this is also very similar to the block-mapped -> extents tool
> from Aneesh.  It doesn't make sense to have so many separate tools for
> users, especially if they start interfering with each other (i.e. defrag
> undoes the remapping done by your tool).

Yep, in fact, I'm really glad that Jan is working on the remapping
tool because if the on-line defrag kernel interfaces don't have the
right support for it, then that means we need to fix the on-line
defrag patches.  :-)

While we're at it, someone want to start thinking about on-line
shrinking of ext4 filesystems?  Again, the same block remapping
interfaces for defrag and file access optimizations should also be
useful for shrinking filesystems (even if some of the files that need
to be relocated are being actively used).  If not, that probably means
we got the interface wrong.

						- Ted
