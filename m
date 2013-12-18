From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: further updates for mke2fs(8) man page
Date: Tue, 17 Dec 2013 20:52:27 -0500
Message-ID: <20131218015227.GC19261@thunk.org>
References: <1387268271-8285-1-git-send-email-adilger@dilger.ca>
 <52B06996.5090005@redhat.com>
 <83B3938A-DEF8-4C05-9511-BA830DCCD692@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Uri Corin <uri.corin@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41128 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab3LRBww (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 20:52:52 -0500
Content-Disposition: inline
In-Reply-To: <83B3938A-DEF8-4C05-9511-BA830DCCD692@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 17, 2013 at 03:22:15PM -0700, Andreas Dilger wrote:
> 
> Actually, the comments about metadata checksums is commented out in
> the man page.  That isn't obvious at first glance.  I had just seen
> it in the previous page, and the old description "a superset of the
> uninit_bg feature" wasn't very useful.

It's commented out because the changes are going into the maint
branch, which does not yet have metadata_csum support.  Once things
settle down, I'll uncomment the text on the next/master branch, but I
didn't want to do that until we were done editing the man pages, to
avoid merge headaches.

I guess most people aren't as conversant with nroff macros any more
--- it was pretty obvious to me they were commented out.  TeX and
LibreOffice has ruined us all.  :-)

> As with anything, no complaints about the previous patch - it definitely
> improved the old content, and there is much more that needs to be done
> to document the metadata checksum feature (tune2fs, e2fsck, etc).

Yes, and many thanks Uri for working on improving the documentation.
It's something that has been badly needed for some time.

Cheers,

					- Ted
