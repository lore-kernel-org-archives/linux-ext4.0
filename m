From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 10:04:01 -0400
Message-ID: <20140505140401.GD22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49803 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbaEEOED (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:04:03 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 03:45:17PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> Now I am actually confused, sorry. Which patches do I need to get thi=
s
> context? I do not see this in the next branch.

These are based on the mke2fs patches I had sent earlier.  Sorry, I
haven't updated the maint branch in a while.

The basic idea behinid these patches is that we now get a bit more
context with the warning message for ext2/3/4 file systems:

% ./misc/mke2fs -t ext4 /dev/heap/media
mke2fs 1.42.9 (4-Feb-2014)
/dev/heap/media contains a ext4 file system labelled 'media'
		  last mounted on /media on Mon May  5 08:59:53 2014
Proceed anyway? (y,n)=20

I have modified those earlier patches in response to your earlier
feedback; we no longer use the 5 second delay by default --- but we
skip doing the check at all if either stdin or stdout is not a tty.
This saves us in the situation where there is some script which does
somethign like this:

mke2fs -t ext4 /dev/sdc3 > /tmp/mke2fs.out

Basically, we will only ask the user for confirmation when we are
certain a user can see both the question and be able to type a
response.  It's possible we could still get confused by someone
running mke2fs under a chat/expect script, but that seems like an
acceptable risk.


					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
