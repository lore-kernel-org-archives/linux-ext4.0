From: Theodore Tso <tytso@mit.edu>
Subject: Re: Crash in 2.6.28.7 - ext4 related
Date: Thu, 26 Feb 2009 11:08:29 -0500
Message-ID: <20090226160829.GH7227@mit.edu>
References: <b637ec0b0902251203i1fe5f081vfd06350dbf5060e9@mail.gmail.com> <b637ec0b0902260118o19f74acal567440a6f049512@mail.gmail.com> <20090226141946.GE7227@mit.edu> <b637ec0b0902260638u2a07433ayf0ea56fd3e41ec5a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37045 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZBZQId (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 11:08:33 -0500
Content-Disposition: inline
In-Reply-To: <b637ec0b0902260638u2a07433ayf0ea56fd3e41ec5a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got the crash image.  Unfortunately the beginning of the Oops
message was cut off, which might have been valuable.  There are some
new patches that are newer than what has been backported to 2.6.28.7;
some of them are in the for-stable branch of the ext4 git tree, and
have been queued for 2.6.28.8.  The call stack doesn't look like one
of the known bugs, though.

Hmm... can you send us the output of dumpe2fs on the filesystem?  And
something that would be very useful would be a raw e2image of the
filesystem, created thusly:

	    e2image -r /dev/sdXXX - | bzip2 > sdXXX.e2i.bz2

This image will contain the basic filesystem metadata, including the
directory blocks (and directory names), but none of the data blocks.
It is therefore much smaller, and if you are willing to let me see
your directory file names, I can take that image and try to replicate
the problem on one of my systems.

If you have a spare 20gb of disk space, you can also unpack the raw
image dump and try reproducing the problem on the raw image dump.  If
you can trigger it easily with an rm -rf operation, it should be just
as reproducible on the raw image dump.

Regards,

						- Ted
