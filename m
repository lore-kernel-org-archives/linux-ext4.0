From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3/9] xfs: factor out everything but the filemap_write_and_wait from xfs_file_fsync
Date: Wed, 21 Nov 2012 09:10:35 -0500
Message-ID: <x49mwybujvo.fsf@segfault.boston.devel.redhat.com>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074138.24645.36708.stgit@blackbox.djwong.org>
	<20121121100913.GF23339@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
	tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2KUPEc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 10:04:32 -0500
In-Reply-To: <20121121100913.GF23339@infradead.org> (Christoph Hellwig's
	message of "Wed, 21 Nov 2012 05:09:13 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
>> Hi,
>> 
>> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
>> function that can be used from the I/O post-processing path.
>
> Why would we need to skip the filemap_write_and_wait_range call here?
> If we're doing direct I/O we should not have any pages in this regions
> anyway.  You're also not skipping it in the generic implementation as
> far as I can see, so I see no point in doing it just in XFS.

OK, I'll fix that.

Thanks!
Jeff
