From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: don't keep using page if inline conversion
 fails
Date: Thu, 11 Sep 2014 11:46:27 -0400
Message-ID: <20140911154627.GC26178@thunk.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
 <20140911002845.10109.10558.stgit@birch.djwong.org>
 <20140911131753.GB30901@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51254 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaIKPqe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 11:46:34 -0400
Content-Disposition: inline
In-Reply-To: <20140911131753.GB30901@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:17:53PM +0200, Jan Kara wrote:
> On Wed 10-09-14 17:28:45, Darrick J. Wong wrote:
> > If inline->extent conversion fails (most probably due to ENOSPC) and
> > we release the temporary page that we allocated to transfer the file
> > contents, don't keep using the page pointer after releasing the page.
> > This occasionally leads to complaints about evicting locked pages or
> > hangs when blocksize > pagesize, because it's possible for the page to
> > get reallocated elsewhere in the meantime.
>   Good catch! You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
