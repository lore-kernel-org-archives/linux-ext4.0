From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented
 byteswapping routines
Date: Mon, 14 Jan 2013 09:13:56 -0500
Message-ID: <20130114141356.GA12052@thunk.org>
References: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43267 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab3ANON6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 09:13:58 -0500
Content-Disposition: inline
In-Reply-To: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 12, 2013 at 04:32:25PM -0300, Cristian Rodr=EDguez wrote:
> In x86, it will not make much difference but other targets that
> are not covered by the old code will be able to generate better code.
>=20
> Signed-off-by: Cristian Rodr=EDguez <crrodriguez@opensuse.org>

The problem is that bswap_{16,32,64}() and the existence of
<byteswap.h> is not guaranted by any standard that I'm not aware of.
A quick Google search indicates that it's not available for the
following platforms:

	* Mac OS X 10.5
	* FreeBSD 6.0
	* NetBSD 5.0
	* OpenBSD 3.8
	* Minix 3.1.8
	* AIX 5.1
	* HP-UX 11
	* IRIX 6.5
	* OSF/1 5.1
	* Solaris 11 2011-11
	* Cygwin
	* mingw
	* MSVC 9
	* Interix 3.5
	* BeOS

So the only way we could use bswap_{16,32,64} if there is a proper
configure.in test for them.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
