From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/8] vfs: Protect write paths by sb_start_write -
 sb_end_write
Date: Tue, 24 Jan 2012 12:44:49 +0100
Message-ID: <20120124114449.GC15974@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
 <1327091686-23177-3-git-send-email-jack@suse.cz>
 <20120124082119.GO15102@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab2AXLow (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 06:44:52 -0500
Content-Disposition: inline
In-Reply-To: <20120124082119.GO15102@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-01-12 19:21:19, Dave Chinner wrote:
> On Fri, Jan 20, 2012 at 09:34:40PM +0100, Jan Kara wrote:
> > There are three entry points which dirty pages in a filesystem.  mmap (handled
> > by block_page_mkwrite()), buffered write (handled by
> > __generic_file_aio_write()), and truncate (it can dirty last partial page -
> > handled inside each filesystem separately). Protect these places with
> > sb_start_write() and sb_end_write().
> 
> fallocate can also dirty pages, either during preallocation or hole
> punching.  Hence if you are going to promote truncate to
> SB_FREEZE_WRITE protection then you need to promote everything else
> that can zero partial blocks as well.
> 
> That also means that anything the has implemented XFS_IOC_ ioctl
> interfaces for prellocation and hole punching (xfs, ocfs2 and gfs2
> IIRC) also needs to be protected in the same way.
  Yeah, you are right. As I wrote in the introductory mail, there's problem
with metadata operations (e.g. directory modifications) anyway so we'll
have to audit all places where transactions are started. First I'll do this
for ext4 as a POC and then I'll try to do that for XFS if Eric doesn't beat
me to it (he promised to have a look at XFS part ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
