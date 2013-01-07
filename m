From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs: =?iso-8859-1?Q?Use?=
 =?iso-8859-1?Q?_=5F=5Fbuiltin=5Fpopcount_when_available_Signed-off-by=3A_?=
 =?iso-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Date: Sun, 6 Jan 2013 20:56:07 -0500
Message-ID: <20130107015607.GC12838@thunk.org>
References: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org>
 <20130106222020.GA9482@thunk.org>
 <50EA1C9B.8040304@opensuse.org>
 <20130107013156.GB12838@thunk.org>
 <50EA28FA.8040205@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42065 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab3AGB4M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jan 2013 20:56:12 -0500
Content-Disposition: inline
In-Reply-To: <50EA28FA.8040205@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 06, 2013 at 10:46:34PM -0300, Cristian Rodr=EDguez wrote:
>=20
> with a recent compiler it goes something like this..

Actually, that's less ugly than I feared...  if we wanted to pretty it
up a little, we could simply omit the __get_cpuid() bit, since that's
x86 specific, and just use the __builtin_cpu_supports() if it is
available on gcc 4.8 and newer.  If it is not available, we could just
always use the software version of popcnt, since it's really not that
bad.

What about the people who prefer to use clang instad of gcc; does
clang have support for any of this magic?

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
