From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Date: Fri, 21 Aug 2009 17:48:29 +0200
Message-ID: <20090821154829.GE3007@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-8-git-send-email-jack@suse.cz> <20090819162638.GE6150@infradead.org> <20090820121531.GC16486@duck.novell.com> <20090820162729.GA24659@infradead.org> <20090821152339.GD3007@duck.novell.com> <20090821153235.GA5874@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
	Joel Becker <joel.becker@oracle.com>,
	Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
	Anton Altaparmakov <aia21@cantab.net>,
	linux-ntfs-dev@lists.sourceforge.net,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932329AbZHUPsa@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090821153235.GA5874@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 21-08-09 11:32:35, Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 05:23:39PM +0200, Jan Kara wrote:
> >   Hmm, I can imagine it would buy us something in two cases (but looking at
> > the code, neither is implemented in such a way that it would really help
> > us in any way):
> > 1) when an inode and it's data are stored in one block (e.g. OCFS2 or UDF) do
> >    this.
> 
> >   In the first case we would wait for block with data to be written only to
> > submit it again because inode was still dirty.
> 
> But we would not actually store in the pagecache or at least never
> writeback it via the pacache in that case, but always just write it as
> part of the inode.
  Yes, probably. Actually, that's what UDF does. It's just that then the
sequence fdatawrite(), fdatawait() does not really send the data to disk.
But that probably does not matter.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
