From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: don't change UUID on a mounted metadata_csum fs
Date: Wed, 30 Sep 2015 12:11:12 -0400
Message-ID: <20150930161112.GA16068@thunk.org>
References: <20150929153122.GJ10390@birch.djwong.org>
 <20150929224621.GC2989@thunk.org>
 <8B6E949A-7397-49BB-84BC-72479FE0F7A7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52070 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbbI3QLQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Sep 2015 12:11:16 -0400
Content-Disposition: inline
In-Reply-To: <8B6E949A-7397-49BB-84BC-72479FE0F7A7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 29, 2015 at 07:21:08PM -0600, Andreas Dilger wrote:
> 
> I don't see how changing the UUID for mounted file systems can work
> for metadata_csum file systems?
> 
> Wouldn't this cause a checksum error for every piece of metadata?

Tune2fs tries to update every piece of metadata when you run a command
like "tune2fs -U random /dev/sda1".  The danger is in the fact that
tune2fs is modifying every bit of metadata while the file system is
mounted.

If you do this with "debugfs -w -R "ssv uuid random" /dev/sda1", it
will break every metadata in the system, because it doesn't try to
update every bit of metadata.

I suppose a better choice might be to add a debugfs command which does
update the UUID, and use that command as an emergency override when
there's no other clean way of handling things.  It's more understood
by users that using debugfs is inherently dangerous, where as it's not
quite as obvious that -f means "here be dragons".  (Hence the
rationale of using "-f -f" which we've used in other cases.)

The problem with --force-uuid is that it means dragging in
getopt_long(), and having a fallback when compiling e2fsprogs on a
system that doesn't support getopt_long(), or if you are using a libc,
such as Bionic, dietlibc, etc., that doesn't have getopt_long().

							- Ted
