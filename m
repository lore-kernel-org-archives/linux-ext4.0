From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Does ext4 send FUA to flush disk cache
Date: Mon, 11 Apr 2011 19:16:06 -0400
Message-ID: <20110411231606.GA9406@infradead.org>
References: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
 <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Busheman <markbusheman@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37472 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab1DKXQH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Apr 2011 19:16:07 -0400
Content-Disposition: inline
In-Reply-To: <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 10, 2011 at 08:17:58AM -0400, Theodore Tso wrote:
> 
> On Apr 8, 2011, at 6:02 PM, Mark Busheman wrote:
> 
> > I plan to use data=journal option with ext4. Would like to know if
> > ext4 send FUA (Forced Unit Access)
> > to flush the disk cache?
> 
> FUA doesn't cause a cache flush.   Ext4 does send cache flush commands, or barriers, to make sure the data written to disk is flushed all the way down to the disk platters on transaction commits.

Ext4 actually does send FUA requests, just grep for it.  With the default
libata config they will be turned into a regular write with a
post-flush, but if you enable the fua module option to the libata module
or use plain SCSI devices the FUA bit (if supported) gets sent all the
way down to the device.

The same also applies to btrfs, gfs2, nilfs2, xfs and if you enable the
non-default config ext3 and reiserfs.  Note that all the filesystem also
do regular flushes as pre-flushes during the journal commit or
equivalent and as part of the fsync implementation.
