From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Thu, 6 Mar 2014 13:32:33 -0500
Message-ID: <20140306183232.GB30706@thunk.org>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
 <1393855228-13592-3-git-send-email-mlombard@redhat.com>
 <20140306154407.GA28226@thunk.org>
 <20140306165416.GA2182@dhcp-27-189.brq.redhat.com>
 <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maurizio Lombardi <mlombard@redhat.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38073 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbaCFSci (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 13:32:38 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 06:54:05PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> All that said, I was getting to rewrite this mess a long time ago,
> it's just a reminder that it's something that needs to be done.
> Especially since the bigger requests are getting split unnecessarily
> which hurts especially in fallocate case.

Hey Lukas,

If you are going to try to do some clean up work in mballoc, that
would be really really great!  (Although hopefully you can still work
on writing down some thoughts about the data block checksum feature
before the ext4 developer's workshop.  :-)

We should try to get input from Andreas about what some of the more
interesting hueristics in mballoc were trying to accomplish, since
there's a lot going on that's not obvious, and one of the reasons why
I've always been worried about trying to do cleanups was because
something that looks ugly might be papering over some other dark
corner of mballoc.c ---- and so I was fairly certain that one we
started opening up mballoc.c, we'd have to do a lot of work on it, and
a lot of performance measurements to make sure we didn't accidentally
introduce some performance regression.

Thanks for being willing to look at this!

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
