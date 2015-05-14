From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] jbd2: fix r_count overflows leading to buffer
 overflow in journal recovery
Date: Thu, 14 May 2015 19:12:42 -0400
Message-ID: <20150514231242.GD3901@thunk.org>
References: <20150514193424.GG30577@birch.djwong.org>
 <20150514204826.GA17985@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37426 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161021AbbENXMp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2015 19:12:45 -0400
Content-Disposition: inline
In-Reply-To: <20150514204826.GA17985@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2015 at 10:48:26PM +0200, Jan Kara wrote:
> On Thu 14-05-15 12:34:24, Darrick J. Wong wrote:
> > The journal revoke block recovery code does not check r_count for
> > sanity, which means that an evil value of r_count could result in
> > the kernel reading off the end of the revoke table and into whatever
> > garbage lies beyond.  This could crash the kernel, so fix that.
> > 
> > However, in testing this fix, I discovered that the code to write
> > out the revoke tables also was not correctly checking to see if the
> > block was full -- the current offset check is fine so long as the
> > revoke table space size is a multiple of the record size, but this
> > is not true when either journal_csum_v[23] are set.
> > 
> > v2: The comparison on the revoke block writer code should allow the
> > revoke block to become totally full.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
