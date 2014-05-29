From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: introduce new i_write_mutex to protect
 fallocate
Date: Thu, 29 May 2014 12:28:10 -0400
Message-ID: <20140529162810.GG25041@thunk.org>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39858 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336AbaE2Q2Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 12:28:16 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405291439340.18491@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 29, 2014 at 02:42:04PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I wonder what is the performance impact of this change ? Especially
> since we're not longer taking the lock only in unaligned aio/dio
> case but in all cases ?

Thinking about this some more, this is also going to break parallel
writes, which would be unfortunate.  We might want to change this to
using a rw mutex, where writes take a shared lock, and require
fallocate to take an exclusive lock....

				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
