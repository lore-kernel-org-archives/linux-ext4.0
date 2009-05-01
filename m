From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Use separate super_operations structure for
	no_journal filesystems
Date: Fri, 1 May 2009 09:48:04 -0400
Message-ID: <20090501134804.GC7681@mit.edu>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu> <1241152637-11986-2-git-send-email-tytso@mit.edu> <1241152637-11986-3-git-send-email-tytso@mit.edu> <20090501070422.GB2107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58988 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761141AbZEANsF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 May 2009 09:48:05 -0400
Content-Disposition: inline
In-Reply-To: <20090501070422.GB2107@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 03:04:22AM -0400, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 12:37:17AM -0400, Theodore Ts'o wrote:
> > By using a separate super_operations structure for filesystems that
> > have and don't have journals, we can simply ext4_write_super() ---
> > which is only needed when no journal is present --- and ext4_freeze(),
> > ext4_unfreeze(), and ext4_sync_fs(), which are only needed when the
> > journal is present.
> 
> FYI: I will make ->sync_fs mandatory pretty soon.  At that point
> ->write_super will only be left for d_dirt-induced periodic writeback.
> (Still have to figure out what to do about file_fsync, but that won't
> affect ext4)

So I'm guessing your plans are to have sys_sync() no longer call
write_super(), but to only call sync_fs()?  If that's the case, I
think all we need to do is set ext4_nojournal_sops.sync_fs to be
ext4_commit_super.

I assume the idea is so that the filesystem can distinguish between
periodic s_dirt writeback versus a request to write the superblock
caused by an explicit fsync or sync system call?

						- Ted
