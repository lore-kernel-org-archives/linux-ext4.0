From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Does ext4 send FUA to flush disk cache
Date: Mon, 11 Apr 2011 22:14:23 -0400
Message-ID: <20110412021423.GC3682@thunk.org>
References: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
 <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
 <20110411231606.GA9406@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Busheman <markbusheman@gmail.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48805 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1DLCO0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2011 22:14:26 -0400
Content-Disposition: inline
In-Reply-To: <20110411231606.GA9406@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 11, 2011 at 07:16:06PM -0400, Christoph Hellwig wrote:
> On Sun, Apr 10, 2011 at 08:17:58AM -0400, Theodore Tso wrote:
> > 
> > On Apr 8, 2011, at 6:02 PM, Mark Busheman wrote:
> > 
> > > I plan to use data=journal option with ext4. Would like to know if
> > > ext4 send FUA (Forced Unit Access)
> > > to flush the disk cache?
> > 
> > FUA doesn't cause a cache flush.   Ext4 does send cache flush commands, or barriers, to make sure the data written to disk is flushed all the way down to the disk platters on transaction commits.
> 
> Ext4 actually does send FUA requests, just grep for it.  With the default
> libata config they will be turned into a regular write with a
> post-flush, but if you enable the fua module option to the libata module
> or use plain SCSI devices the FUA bit (if supported) gets sent all the
> way down to the device.

Ah, Jens pushed a patch that I hadn't noticed that appears to
optionally use FUA for the commit block.  Thanks for pointing that
out.

						- Ted
