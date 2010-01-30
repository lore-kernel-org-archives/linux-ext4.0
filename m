From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Date: Sat, 30 Jan 2010 12:31:26 -0600
Message-ID: <4B647AFE.5000507@sandeen.net>
References: <4B633F9A.8000404@sandeen.net> <20100130105501.GA22909@infradead.org> <4B645B0D.205@sandeen.net> <20100130172502.GA788@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Giel de Nijs <giel@vectorwise.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-60-146.usfamily.net ([64.131.60.146]:58395 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0A3Sb1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 13:31:27 -0500
In-Reply-To: <20100130172502.GA788@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Sat, Jan 30, 2010 at 10:15:09AM -0600, Eric Sandeen wrote:
>>> me on a 32-bit machine.  The patch below fixes it up, but it seems like
>>> we should rather add a variant of that code as aio_read/write commands
>>> to xfs_io instead of adding a new test program.
>> ok, that's probably better - again, though, it takes at least a release
>> cycle before most folks can test it.  But I guess that's not the end of
>> the world.
> 
> Stupid question --- who uses xfs_io besides xfstests?  Any chance we
> could consider dropping in some version of xfs_io into xfstests, or
> actually moving it into xfstests from xfsprogs if xfstests is the
> exclusive user of that program?  I've been trying to get more people
> to use xfstests, since it would be good if more companies and more
> projects were using it --- and one of the things that makes it hard is
> all of the dependencies that it has.  If there was some way we could
> gradually make xfstests more self-contained, it would certainly be
> nice.
> 
> 						- Ted

These are the deps that I know xfstests has, to build and to run:

BuildRequires:  autoconf, libtool, xfsprogs-devel, e2fsprogs-devel
BuildRequires:  libacl-devel, libattr-devel, libaio-devel

Requires:       bash, xfsprogs, xfsdump, perl, acl, attr, bind-utils
Requires:       bc, indent, quota

which isn't so bad...
(and tests are just skipped if xfsdump isn't there)

I'm not sure an xfsprogs dependency is so onerous; plenty has depended
on e2fsprogs through the years and we've lived with that ;)  But
the lag time for xfsprogs to use released xfs_io functionality is a
bit of a bummer.

But I guess I don't have a great answer for who else uses xfs_io:

xfs_io(8)                                            xfs_io(8)

NAME
       xfs_io - debug the I/O path of an XFS filesystem

SYNOPSIS
       xfs_io [ -adFfmrRstx ] [ -c cmd ] ... [ -p prog ] file

DESCRIPTION
       xfs_io  is a debugging tool like xfs_db(8), but is aimed
       at examining the regular file I/O paths rather than  the
       raw  XFS  volume  itself. 

I guess it's not really advertised as a generic tool, and it's
in the sbin path...

I guess I could live with it either way - I suppose my main concern
is that xfstests is a mess to package for a distro, and I really like
easy access to xfs_io for my own use outside of xfstests.

-Eric
