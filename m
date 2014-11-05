From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] Some thoughts about providing data block checksumming
 for ext4
Date: Tue, 4 Nov 2014 21:33:37 -0500
Message-ID: <20141105023337.GA324@thunk.org>
References: <20141103233308.GA27842@thunk.org>
 <alpine.LRH.2.02.1411041622490.30941@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39169 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbaKECdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 21:33:41 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1411041622490.30941@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2014 at 04:39:55PM -0500, Mikulas Patocka wrote:
> 
> 
> On Mon, 3 Nov 2014, Theodore Ts'o wrote:
> 
> > But there is a way we can do even better!  If we can manage to
> > compress the block even by a tiny amount, so that 4k block can be
> > stored in 4092 bytes (which means we need to be able to compress the
> > block by 0.1%), we can store the checksum inline with the data, which
> > can then be atomically updated assuming a modern drive with a 4k
> > sector size (even a 512e disk will work fine, assuming the partition
> > is properly 4k aligned).  If the block is not sufficiently
> 
> There is still large number of drives with 512-byte sectors in use. So 
> we'd rather use 512-byte block?

There are a lot of systems (including Oracle IIRC) that use 4k blocks
and checksums, and accept the fact that very rarely it's possible that
even though writes are sent in chunks of 4k, it's possible (although
in general fairly rare) to have "torn writes" after a power failure. 

I'd much rather design for the future and not try to tie ourselves in
knots about the possibility of some torn writes on 512 byte sector
disks.  Many other file systems and databases have made similar
assumptions (and in fact have for years; I remember stories about
Oracle and another enterprise database having to deal with torn
writes eight years ago).

							- Ted
