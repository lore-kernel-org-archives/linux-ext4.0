From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_fallocate
Date: Mon, 2 Jul 2012 14:01:50 -0400
Message-ID: <20120702180150.GB5795@thunk.org>
References: <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
 <20120702031611.GB2406@gmail.com>
 <4FF1CD5D.8010904@redhat.com>
 <20120702174421.GM6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54021 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2GBSB7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 14:01:59 -0400
Content-Disposition: inline
In-Reply-To: <20120702174421.GM6679@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 02, 2012 at 07:44:21PM +0200, Jan Kara wrote:
>   Yes, that option is broken and basically unfixable for data=ordered mode
> (see http://comments.gmane.org/gmane.comp.file-systems.ext4/30727). For
> data=writeback it works fine AFAICT.

The journal_async_commit option can be saved, but it requires changing
how we handle stale data.  What we need to do is to change things so
that we update the metadata *after* the data has been written back.
We do this already if the experimental dioread_nolock code is used,
but currently it only works for 4k blocks. 

The I/O tree work will give us the infrastructure we need so we can
easily update the metadata after the data blocks have been written out
when we are extending or filling in a sparse hole, even when the block
size != page size.  (This is why we can't currently make the
dioread_nolock code path the default; it would cause things to break
on 1k/2k file systems, as well as 4k file systems on Power.)  But once
this is done, it will allow us to subsume and rip out dioread_nolock
code[path, and the distinction between ordered and writeback mode.

Also, the metadata checksum patches will fix the other potential
problem with using journal_async_commit, which is that it adds
fine-grained checksums in the journal, so we can recover more easily
from a corrupted journal.

So once all of this is stable, we'll be able significantly simplify
the ext4 code and our testing matrix, and get all of the benefits of
data=writeback, dioread_nolock, and journal_async_commit, without any
of their current drawbacks.  Which is why I've kept on pestering Zheng
about how the I/O tree work has been coming along on the ext4 calls;
it's going to enable some really cool things.  :-)

    	       	     	      		    - Ted
