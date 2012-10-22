From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 hanlding of ext2/3 mount options
Date: Mon, 22 Oct 2012 00:53:17 -0400
Message-ID: <20121022045317.GF4768@thunk.org>
References: <20121018181515.GA13898@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56757 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2JVExY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2012 00:53:24 -0400
Content-Disposition: inline
In-Reply-To: <20121018181515.GA13898@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 18, 2012 at 03:15:15PM -0300, Carlos Maiolino wrote:
> Hey Ted, how's going?
> 
> I was wondering if when using Ext4 module to mount ext2/3
> filesystems (not conversion), if the ext4 module shouldn't fail a
> mount of ext2/3 if a ext4-only mount option has been passed to it.
> 
> For example:
> 
> mount -t ext3 -o journal_checksum <dev> <mount_point> 
> 
> this works and the FS is properly mounted, although journal_checksum
> is not a valid ext3 mount option.
> 
> Should this be considered a bug?

Hmmm.... in general, I don't think using ext4-specific mount options
should be considered a bug with file systems whose features are
consistent with what was used with ext2 or ext3 file system drivers in
the past.  After all, we might want to allow users to experiment
without converting their file systems to ext4 --- especially since we
don't have a way of going from ext4 to ext2/3.

However, it is related to something that Eric has been wanting to code
up for a while, but as far as I know he wasn't had the time.
Specifically, the goal is to create some kind of compact way of
encoding a combination of file system features and mount options which
are "supported".  It's not clear whether this can be done in a
table-driven way, or it whether it would have to be expressed in a
series of conditionals in C code (and it brings up the question of
what combinations of file system features and mount options should be
considered "supported").

The basic idea is that for upstream kernels, if users try to use an
"unsupported" set of file system features and/or mount options, the
kernel would print a warning message indicating that they had used an
unsupported combination of features, and to please contact the ext4
mailing list so we can find out why they are using that combination of
features (so I and others who run ext4 tests on upstream kernels can
decide whether we would want to increase our test matrix or not).

For distribution kernels, I expect that distros might want to use a
much more restrictive set of file system features and mount options,
and if the user uses something which is "not supported", the distro
could decide that they have a policy whether they print message saying
that this was not supported, or they could taint the kernel, or
whatever.  But then that can be left up to each distro to decide what
they are willing to "support".

I imagine there would probably be a set of file system features and
mount options where we don't care whether they are enabled or not, and
there might be a few file system features where they _must_ be
enabled, and some file system features where they must not be enabled
for the file system to be considered features --- and then there might
be some interesting questions of how various mount options and file
system features interact with one another, and whether a distribution
might want to be so restrictive as to say, "we only support this
specific, exact, set of file system features, and no others".

Exactly what those combinations might be I suspect would be at least
somewhat controversial....

	  	  	     	     	    - Ted
