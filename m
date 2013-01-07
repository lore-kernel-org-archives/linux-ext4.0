From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs: =?iso-8859-1?Q?Use?=
 =?iso-8859-1?Q?_=5F=5Fbuiltin=5Fpopcount_when_available_Signed-off-by=3A_?=
 =?iso-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Date: Sun, 6 Jan 2013 20:31:56 -0500
Message-ID: <20130107013156.GB12838@thunk.org>
References: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org>
 <20130106222020.GA9482@thunk.org>
 <50EA1C9B.8040304@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42059 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab3AGBcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jan 2013 20:32:00 -0500
Content-Disposition: inline
In-Reply-To: <50EA1C9B.8040304@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 06, 2013 at 09:53:47PM -0300, Cristian Rodr=EDguez wrote:
>=20
> Yeah, I asked GCC developers exactly this, was told to fill a
> enhancement request.

If you could also sned them a bug/enhancement request to use a more
optimized version of __popcountdi2, that would be great.  I'm not sure
it helps e2fsprogs much, since it's too hard for us to tell whether we
are using a version of the gcc runtime that has a optimized or
unuptomized version of builtin_popcount().

But since it doesn't make that much difference, my preference is to
just ignore builtin_popcount() for now.  If someone is really using
128TB ext4 file systems, and cares about that extra 6 seconds of CPU,
it's probably going to require the ugly approach of using x86 asm
statements to determine whether or not we're running on a CPU that
supports the popcount instruction or not....

						- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
