From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] jbd2: reduce the number of writes when commiting a
 transacation
Date: Tue, 24 Apr 2012 23:57:09 +0200
Message-ID: <20120424215709.GA7636@quack.suse.cz>
References: <20120420110627.GA30373@gmail.com>
 <E5D2F131-A01C-4CB2-8A7C-88CACBBC450B@dilger.ca>
 <20120423022505.GA7855@gmail.com>
 <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114Ab2DXV5R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 17:57:17 -0400
Content-Disposition: inline
In-Reply-To: <67060CC0-9F64-40ED-9467-572996ECF21F@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 23-04-12 01:24:39, Andreas Dilger wrote:
> On 2012-04-22, at 21:25, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Fri, Apr 20, 2012 at 05:21:59AM -0600, Andreas Dilger wrote:
> >> 
> >> 
> >> The reason that there are two separate writes is because if the write
> >> of the commit block is reordered before the journal data, and only the
> >> commit block is written before a crash (data is lost), then the journal
> >> replay code may incorrectly think that the transaction is complete and
> >> copy the unwritten (garbage) block to the wrong place.
> >> 
> >> I think there is potentially an existing solution to this problem,
> >> which is the async journal commit feature.  It adds checksums to the
> >> journal commit block, which allows verifying that all blocks were
> >> written to disk properly even if the commit block is submitted at
> >> the same time as the journal data blocks.
> >> 
> >> One problem with this implementation is that if an intermediate
> >> journal commit has a data corruption (i.e. checksum of all data
> >> blocks does not match the commit block), then it is not possible
> >> to know which block(s) contain bad data.  After that, potentially
> >> many thousands of other operations may be lost.
> >> 
> >> We discussed a scheme to store a separate checksum for each block
> >> in a transaction, by storing a 16-bit checksum (likely the low
> >> 16 bits of CRC32c) into the high flags word for each block.  Then,
> >> if one or more blocks is corrupted, it is possible to skip replay
> >> of just those blocks, and potentially they will even be overwritten
> >> by blocks in a later transaction, requiring no e2fsck at all.
> > 
> > Thanks for pointing out this feature.  I have evaluated this feature in my
> > benchmark, and it can dramatically improve the performance. :-)
> > 
> > BTW, out of curiosity, why not set this feature on default?
> 
> As mentioned previously, one drawback of depending on the checksums for
> transaction commit is that if one block in and of the older transactions
> is bad, then this will cause the bad block's transaction to be aborted,
> along with all of the later transactions.
  Also currently the async commit code has essentially unfixable bugs in
handling of cache flushes as I wrote in
http://www.spinics.net/lists/linux-ext4/msg30452.html. Because data blocks
are not part of journal checksum, it can happen with async commit code that
data is not safely on disk although transaction is completely committed. So
async commit code isn't really safe to use unless you are fine with
exposure of uninitialized data...

								Honza
