From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext2: add wait flag support to sync_fs
Date: Fri, 20 Nov 2009 22:06:37 +0100
Message-ID: <20091120210637.GC15631@duck.suse.cz>
References: <20091117174617.285298261@vyatta.com>
 <20091117174647.402219318@vyatta.com>
 <20091119153419.GB2943@atrey.karlin.mff.cuni.cz>
 <20091120103622.GA29143@infradead.org>
 <20091120090858.62ae15b3@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbZKTVGc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 16:06:32 -0500
Content-Disposition: inline
In-Reply-To: <20091120090858.62ae15b3@nehalam>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 20-11-09 09:08:58, Stephen Hemminger wrote:
> On Fri, 20 Nov 2009 05:36:22 -0500
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Thu, Nov 19, 2009 at 04:34:19PM +0100, Jan Kara wrote:
> > >   BTW: Christoph, why did you choose to call ext2_sync_fs with wait == 1
> > > from ext2_write_super()? I'd think (and looking into callsites seem to
> > > confirm that) that ->write_super() was meant to be asynchronous...
> > 
> > No particular reason - the argument wasn't and still isn't used in ext2.
> > And yes, now that ->sync_fs is mandatory ->write_super should be
> > asynchronous.
> 
> Shouldn't super block (and all other) updates be synchronous if ext2 
> is mounted with SYNC and DIRSYNC?
  Well, looking at the code, we don't seem to do that ;) Maybe we should
but would it really bring anything? The only thing which will go wrong are
counters of free blocks and inodes and those will be recomputed by fsck
anyway. And note that SYNC does not guarantee you that you don't need fsck
if you just pull the device out without umount. It just limits the
damage...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
