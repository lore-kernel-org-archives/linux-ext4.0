From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: info about filesystem errors in /sys/fs/ext4/... ?
Date: Mon, 5 May 2014 07:59:19 -0400
Message-ID: <20140505115919.GB18305@thunk.org>
References: <20140505070823.GM3017@pcnci.linuxbox.cz>
 <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49495 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431AbaEEL70 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 07:59:26 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 01:03:17PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> However we might to go a step further, because I do not
> really like the idea of allowing to mount the file system with
> errors by default. It does not really make sense to me and I wonder
> whether someone actually intend to do it this way.

We would need to make an exception for the root file system, of
course.  And I've been receiving patches from folks who want to allow
e2fsck to be able to fix a mounted, read-only /usr partition, since
systemd is forcing folks to have to mount /usr read-only before it
will start, which means /usr needs to be mounted before e2fsck gets
started by systemd.

So that implies that we may need to have an exception for certain
non-root file systems as well, if we want to disallow mounting file
systems that have errors by default.  Or perhaps we should only
disallow read/write mounts of file systems that have errors without
some kind of override mount option.  Although I'm not sure we could
just start doing that by default without breaking some set of systems
and their current set of init scripts.


As far as determining whether or not a file system has errors, having
a /sys entry makes sense; although userspace could just read this out
of the ext2/3/4 superblock directly.

I'll note that internally inside Google, we've used multiple
mechanisms over time and for different use cases.  In some cases we've
scraped the system log files; in some cases we've used a hack that
redirected ext4_error() information into a custom semi-structured data
stream delivered via a netlink socket; and in some cases we've had a
userspace daemon parse the output of "dumpe2fs -h /dev/XXX".

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
