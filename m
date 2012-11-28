From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem corruption on Fedora 17
Date: Wed, 28 Nov 2012 16:15:55 -0500
Message-ID: <20121128211555.GA30650@thunk.org>
References: <CAP5prOgjNXnvXr1HELuez7+Be+TW4N8t9P_AeQw8pBVYDnFHTg@mail.gmail.com>
 <20121127164745.GB7107@thunk.org>
 <CAP5prOh1VvLtCvY_iE2om2dXmgwHoD5JkkfVqu=MUtMiv9L9vg@mail.gmail.com>
 <20121127173115.GC7107@thunk.org>
 <CAP5prOhXZS+x4xAEOYcTquVFz9rtTVeyhK_x2qajKGoKxfw5vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Adam Huffman <adam.huffman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35548 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab2K1VP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 16:15:59 -0500
Content-Disposition: inline
In-Reply-To: <CAP5prOhXZS+x4xAEOYcTquVFz9rtTVeyhK_x2qajKGoKxfw5vA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 06:16:40PM +0000, Adam Huffman wrote:
> > Can you send me a copy of the output of:
> >
> > debugfs -w /dev/XXXX
> > debugfs: stat <4122234>
> 
> debugfs:  stat 4122234
> 4122234: File not found by ext2_lookup

You need the angle brackets.  A number in angle brackets is
interpreted as an inode number.  Without the angle brackets then
debugfs tries to do a lookup in the debugfs's current working directory.

> As I said in the other reply, I was able to mount the image in the
> end.  Perhaps one of those fsck invocations made a difference, even
> though the same error appeared each time?

Well, if e2fsck doesn't fix a corruption in a single pass, barring
hardware failures, it's a bug in e2fsck by definition (at least in my
book).  If the same error is appearing each time, that doesn't mean
that the file system can't be mounted.  Unless you actually try to
reference the corrupted inode in question, you might never know about
the corruption.

You can use the ncheck command in debugfs if you want to map an inode
number to a pathname.  ("ncheck 4122234" --- no angle brackets since
ncheck only takes inode numbers and maps them to pathnames, just as
icheck takes block numbers and maps them to inode numbers).

       	     	   	       	    	 - Ted
