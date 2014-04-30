From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7] mke2fs: only print the low-level file system stats
 in verbose mode
Date: Wed, 30 Apr 2014 10:01:50 -0400
Message-ID: <20140430140150.GA9213@thunk.org>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu>
 <1398556834-31913-7-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1404301316180.2100@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41926 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055AbaD3OBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 10:01:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404301316180.2100@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 30, 2014 at 01:22:52PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Sat, 26 Apr 2014, Theodore Ts'o wrote:
>=20
> > Date: Sat, 26 Apr 2014 20:00:34 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Subject: [PATCH 7/7] mke2fs: only print the low-level file system s=
tats in
> >     verbose mode
>=20
> While I kind of like this, because mke2fs is really quite verbose as
> it is. However I am afraid that this will break scripts for people.

Are there scripts that are really trying to parse the output of
mke2fs?  The output hasn't really been _that_ stable.  I'm sure we've
added stuff in the past, althoughg admittedly the this is the first
time that we would be removing stuff.

> Also there are actually some useful information in that output like
> block size, size of the file system and file system label if
> specified. Also maybe having UUID in there will be also useful.

The block sizs is pretty much always 4k, and the file system label is
only there if the user specified one on the command line.  I can see
how the size and UUID might be useful, though.

How about if we just print the size and UUID?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
