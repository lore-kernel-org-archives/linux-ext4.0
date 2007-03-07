From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Wed, 7 Mar 2007 09:51:35 +0100
Message-ID: <20070307085135.GB29373@duck.suse.cz>
References: <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz> <45EC7773.7020603@us.ibm.com> <20070306072850.GA23081@infradead.org> <45ED7C59.4050508@redhat.com> <20070306145009.GB3661@duck.suse.cz> <45EDB19A.6030103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Drepper <drepper@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>, nscott@aconex.com,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39071 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161327AbXCGIq1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2007 03:46:27 -0500
Content-Disposition: inline
In-Reply-To: <45EDB19A.6030103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 06-03-07 12:23:22, Eric Sandeen wrote:
> Jan Kara wrote:
> > On Tue 06-03-07 06:36:09, Ulrich Drepper wrote:
> >> Christoph Hellwig wrote:
> >>> fallocate with the whence argument and flags is already quite complicated,
> >>> I'd rather have another call for placement decisions, that would
> >>> be called on an fd to do placement decissions for any further allocations
> >>> (prealloc, write, etc)
> >> Yes, posix_fallocate shouldn't be made more complicated.  But I don't
> >> understand why requesting linear layout of the blocks should be an
> >> option.  It's always an advantage if the blocks requested this way are
> >> linear on disk.  So, the kernel should always do its best to make this
> >> happen, without needing an additional option.
> >   Actually, it's not that simple. You want linear layout of blocks you are
> > going to read. That is not necessary a linear layout of blocks in a single
> > file - trace sometime a start of some complicated app like KDE. You find
> > it's seeking like a hell because it needs a few blocks from a ton of
> > distinct files (shared libs, config files, etc). As these files are mostly
> > read only, it's advantageous to interleave them on disk or at least keep
> > them close.
> 
> At some point shouldn't the apps be fixed, rather than do crazy things
> with the filesystem?  :)
  Yes :) That's basically what we told KDE developpers when they were
complaining ;) But it's hard to fix it for them too (because of some
desktop specs requiring lots of different text config files which can
change anytime - don't ask me who designed it). Moreover for example for
loading shared libraries from which you need just a few blocks scattered
all over the place the problem is in ELF itself.
  I'll probably first write some userspace fs-reorganizer to find out how
much these changes in layout are able to give you in performance (i.e.
whether it's worth the effort of more complicated kernel online
defragmenter).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
