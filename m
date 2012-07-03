From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_fallocate
Date: Tue, 3 Jul 2012 11:30:29 +0200
Message-ID: <20120703093029.GS6679@quack.suse.cz>
References: <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
 <20120702180150.GB5795@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Fredrick <fjohnber@zoho.com>, Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab2GCJad (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2012 05:30:33 -0400
Content-Disposition: inline
In-Reply-To: <20120702180150.GB5795@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-07-12 14:01:50, Ted Tso wrote:
> On Mon, Jul 02, 2012 at 07:44:21PM +0200, Jan Kara wrote:
> >   Yes, that option is broken and basically unfixable for data=ordered mode
> > (see http://comments.gmane.org/gmane.comp.file-systems.ext4/30727). For
> > data=writeback it works fine AFAICT.
> 
> The journal_async_commit option can be saved, but it requires changing
> how we handle stale data.  What we need to do is to change things so
> that we update the metadata *after* the data has been written back.
> We do this already if the experimental dioread_nolock code is used,
> but currently it only works for 4k blocks. 
  This won't save us. The problem with async commit is that in the
sequence:
write data
wait for data write completion
change metadata
write transaction with changed metadata
write commit block
CACHE_FLUSH

if you flip power switch just before CACHE_FLUSH, disk could have cached
stuff so that the whole transaction made it to pernament storage but data
didn't. So recovery will happily replay the transaction and make unwritten
disk blocks accessible. There is no simple way around this problem except
for issuing CACHE_FLUSH sometime after data writes have completed and
before you write commit block...

And if you ask about the complicated way ;-): You can compute data
checksum, add it to the transaction and check it on replay.

> The I/O tree work will give us the infrastructure we need so we can
> easily update the metadata after the data blocks have been written out
> when we are extending or filling in a sparse hole, even when the block
> size != page size.  (This is why we can't currently make the
> dioread_nolock code path the default; it would cause things to break
> on 1k/2k file systems, as well as 4k file systems on Power.)  But once
> this is done, it will allow us to subsume and rip out dioread_nolock
> code[path, and the distinction between ordered and writeback mode.
> 
> Also, the metadata checksum patches will fix the other potential
> problem with using journal_async_commit, which is that it adds
> fine-grained checksums in the journal, so we can recover more easily
> from a corrupted journal.
> 
> So once all of this is stable, we'll be able significantly simplify
> the ext4 code and our testing matrix, and get all of the benefits of
> data=writeback, dioread_nolock, and journal_async_commit, without any
> of their current drawbacks.  Which is why I've kept on pestering Zheng
> about how the I/O tree work has been coming along on the ext4 calls;
> it's going to enable some really cool things.  :-)
  Yeah, this would be good stuff. Just it won't be enough for
journal_async_commit in data=ordered mode...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
