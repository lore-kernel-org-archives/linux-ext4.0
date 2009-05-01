From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] ext4: Use separate super_operations structure for
	no_journal filesystems
Date: Fri, 1 May 2009 10:24:03 -0400
Message-ID: <20090501142403.GA4493@infradead.org>
References: <1241152637-11986-1-git-send-email-tytso@mit.edu> <1241152637-11986-2-git-send-email-tytso@mit.edu> <1241152637-11986-3-git-send-email-tytso@mit.edu> <20090501070422.GB2107@infradead.org> <20090501134804.GC7681@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbZEAOYF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 10:24:05 -0400
Content-Disposition: inline
In-Reply-To: <20090501134804.GC7681@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 09:48:04AM -0400, Theodore Tso wrote:
> So I'm guessing your plans are to have sys_sync() no longer call
> write_super(), but to only call sync_fs()?  If that's the case, I
> think all we need to do is set ext4_nojournal_sops.sync_fs to be
> ext4_commit_super.
> 
> I assume the idea is so that the filesystem can distinguish between
> periodic s_dirt writeback versus a request to write the superblock
> caused by an explicit fsync or sync system call?

Exactly.  The plan is to use write_super only for peridoic writeback,
everything that is used for data integrity will go through ->sync_fs.

We'll grow a couple more ->sync_fs instances, but I think the result
is a lot more logic.  We'll also avoid the mostly useless double
sb writes due to ->write_super being called for both the wait = 0 and
wait = 1 cases in sync.
