From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/4 v2] e2fsck: make a prompt message simpler and thus
 translatable
Date: Wed, 4 Jun 2014 10:42:39 -0400
Message-ID: <20140604144239.GI27426@thunk.org>
References: <20140602234001.GJ30598@thunk.org>
 <1401827722-13286-1-git-send-email-bensberg@justemail.net>
 <20140604020719.GC27426@thunk.org>
 <1401884601.6870.125052445.0CA47507@webmail.messagingengine.com>
 <20140604125650.GF27426@thunk.org>
 <1401888336.22807.125078021.186DE367@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benno Schulenberg <bensberg@justemail.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50056 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaFDOmm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 10:42:42 -0400
Content-Disposition: inline
In-Reply-To: <1401888336.22807.125078021.186DE367@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 03:25:36PM +0200, Benno Schulenberg wrote:
> 
> On Wed, Jun 4, 2014, at 14:56, Theodore Ts'o wrote:
> > On Wed, Jun 04, 2014 at 02:23:21PM +0200, Benno Schulenberg wrote:
> > > 
> > > Running 'make check' now, I see these messages along the way:
> > > 
> > > mktemp: too few X's in template `r_64bit_big_expand.XXXXXX.tmp'
> 
> This "too few X's" is misleading -- what it intends to say is that it
> sees zero X's in the final component of the name, "tmp".

In the posix specification, "component" has a specific meaning, and it
means the last part of a pathname.  For example the "basename" command
is described as removing all of the leading directory components.
NAME_LEN is defined to be the maximum length of a pathname component,
etc.

I don't think your reading of the word "component" is correct.

> > Hmm... what OS and if Linux, version of coreutils are you using?
> 
> Ubuntu Lucid, 2010.04, mktemp --version | head -1
> mktemp (GNU coreutils) 8.13

OK, interesting.  It seems to work just fine using coreutils 8.21
(Debian Testing).  And I just checked on one of my Debian Stable
machines, which is using coreutils 8.13-3.5, and it's working there.

% mktemp /tmp/r_64bit_big_expand.XXXXXX.tmp
/tmp/r_64bit_big_expand.QAOy36.tmp

... and I just tried it on a Ubuntu 12.04 machine, and it accepts it
too:

8% cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04.4 LTS"
% mktemp -V
mktemp (GNU coreutils) 8.13
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Jim Meyering and Eric Blake.
% mktemp /tmp/r_64bit_big_expand.XXXXXX.tmp     
/tmp/r_64bit_big_expand.6yNF5W.tmp


Hmm... I just checked on a Mac OSX machine, which is using a FreeBSD
userspace iirc, and its man page explicitly states that six X's must
be at the end of the pathname.  And while "mktemp /tmp/foo.XXXXXX.bar"
doesn't fail, it returns "/tmp/foo.XXXXXX.bar", and if
/tmp/foo.XXXXXX.bar already exists, only then will it fail with a
"File exists" error message.

So it looks like allowing the placement of the XXX characters in the
middle of the filename is a GNU coreutils extension, and it must have
been introduced very shortly after Ubuntu 10.04 snapshotted its
coreutils package from Debian.  And since most of our developers
aren't using something quite as antique as Ubuntu 10.04, and while we
do have someone doing test compiles on Mac OSX, the fact that mktemp
generally works there means that Andreas never saw any problems with
it.

					- Ted
