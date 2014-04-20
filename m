From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc,
 e4defrag...)
Date: Sun, 20 Apr 2014 16:00:30 -0400
Message-ID: <20140420200030.GC29727@thunk.org>
References: <534F39F6.2000208@ovh.fr>
 <20140417152457.GE18591@thunk.org>
 <5350205E.3030403@ovh.fr>
 <alpine.LFD.2.00.1404181042200.2128@localhost.localdomain>
 <5353DBC2.5080708@ovh.fr>
 <20140420190146.GB29727@thunk.org>
 <53542236.9030201@ovh.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Contact <neitsab@ovh.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50841 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbaDTUAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Apr 2014 16:00:34 -0400
Content-Disposition: inline
In-Reply-To: <53542236.9030201@ovh.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 20, 2014 at 09:38:30PM +0200, Contact wrote:
> > Note that because this uses a new compat feature, "sparse_super2", if
> > you use the new mke2fs to create such a file system, you will also
> > need to make sure the file system is checked using a version of e2fsck
> > that supports this new feature as well.  No kernel changes are
> > required to support this, though.
> >
> Any plans to get this feature into master at some point in the 
> development?

The maint branch is regularly merged into the master and next
branches, so it's there today.  The maint branch will very shortly be
the source of a 1.42.10 maintenance release.

The master branch will eventualy be a 1.43 release; it has some much
more disruptive changes, and adds support for metadata checksums,
inline data, etc.  It's likely that 1.42.10 will be the last
maintenance release, and the focus will be on stablizing 1.43 and
making sure we're really ready to support the ABI's for the new
library functions in libext2fs to support these new features _forever_.

Cheers,

					- Ted
