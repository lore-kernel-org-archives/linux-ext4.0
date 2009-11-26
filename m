From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Report metadata errors during fsync
Date: Thu, 26 Nov 2009 14:31:39 +0100
Message-ID: <20091126133139.GB4834@quack.suse.cz>
References: <1259144693-6732-1-git-send-email-jack@suse.cz>
 <20091125134858.97ca863d.akpm@linux-foundation.org>
 <537036C8-472F-4111-8B00-7A637A00845E@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbZKZNbi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Nov 2009 08:31:38 -0500
Content-Disposition: inline
In-Reply-To: <537036C8-472F-4111-8B00-7A637A00845E@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-11-09 16:17:32, Andreas Dilger wrote:
> On 2009-11-25, at 14:48, Andrew Morton wrote:
> >On Wed, 25 Nov 2009 11:24:53 +0100
> >Jan Kara <jack@suse.cz> wrote:
> >>When an IO error happens while writing metadata buffers, we should
> >>better report it and call ext2_error since the filesystem is probably
> >>no longer consistent. Sometimes such IO errors happen while flushing
> >>thread does background writeback, the buffer gets later evicted
> >>from memory, and thus the only trace of the error remains as
> >>AS_EIO bit
> >>set in blockdevice's mapping. So we check this bit in ext2_fsync and
> >>report the error although we cannot be really sure which buffer we
> >>failed to write.
> >
> >So this doesn't cause significant changes in runtime behaviour unless
> >the operator specified errors=remount-ro or errors=panic?
> 
> 
> Debian, at least, always mounts filesystems with errors=remount-ro.
> 
> I _was_ thinking that this would cause errors for even regular file
> data, but since it is the bdev mapping and regular files have their
> own mappings any errors on the regular files should appear on a
> different mapping (which is eventually returned via simple_fsync()).
>
> The only errors returned from the bdev mapping should be metadata
> errors, and we always want to call ext*_error() for those.
  Exactly. Since ext2 handles also directories via page cache, even errors
in directory blocks will not end up in block device's page cache.


								Honza
