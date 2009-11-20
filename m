From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 2/2] ext2: add wait flag support to sync_fs
Date: Fri, 20 Nov 2009 09:08:58 -0800
Message-ID: <20091120090858.62ae15b3@nehalam>
References: <20091117174617.285298261@vyatta.com>
	<20091117174647.402219318@vyatta.com>
	<20091119153419.GB2943@atrey.karlin.mff.cuni.cz>
	<20091120103622.GA29143@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	hch@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:40992 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbZKTRJN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2009 12:09:13 -0500
In-Reply-To: <20091120103622.GA29143@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 20 Nov 2009 05:36:22 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Nov 19, 2009 at 04:34:19PM +0100, Jan Kara wrote:
> >   BTW: Christoph, why did you choose to call ext2_sync_fs with wait == 1
> > from ext2_write_super()? I'd think (and looking into callsites seem to
> > confirm that) that ->write_super() was meant to be asynchronous...
> 
> No particular reason - the argument wasn't and still isn't used in ext2.
> And yes, now that ->sync_fs is mandatory ->write_super should be
> asynchronous.
> 

Shouldn't super block (and all other) updates be synchronous if ext2 
is mounted with SYNC and DIRSYNC?

-- 
