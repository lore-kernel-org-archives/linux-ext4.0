From: tytso@mit.edu
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Tue, 18 Mar 2014 08:39:19 -0400
Message-ID: <20140318123919.GA25897@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <20140316190820.GB14162@thunk.org>
 <alpine.LFD.2.00.1403171358580.30625@localhost.localdomain>
 <20140317210030.GB15218@thunk.org>
 <alpine.LFD.2.00.1403181230270.2121@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoSBDemVybmVyIDxsY3plcm5lckByZWRoYXQuY29tPg==?=@thunk.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43008 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaCRMjX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2014 08:39:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403181230270.2121@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 18, 2014 at 12:37:47PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Ok, finally I got it. The problem is that we now have commit=20
>=20
> 97d39798f77aef626130db8590cc79195300227b ext4: delete path dealloc
> code in ext4_ext_handle_uninitialized_extents
>=20
> which I was not aware of before. And when merging you have used the
> same out2 label out of the function. However when creating my new
> function ext4_ext_convert_initialized_exten() so I've done the same
> thing as with ext4_ext_handle_uninitialized_extents() and freed the
> path. And since we do not set path to NULL in ext4_ext_map_blocks
> after calling ext4_ext_convert_initialized_extent() when we hit the
> condition at the out2:
>=20
> 	if (path) {
> 		ext4_ext_drop_refs(path);
> 		kfree(path);
> 	}
>=20
> we will double-free possibly destroying data from someone else. That
> is why we've seen what looked like a random memory corruption.

My bad!  I remember noticing that particular semantic conflict, and I
*thought* I had fixed it up.  The fixup must have gotten lost when I
was doing some patch wrangling (I was moving aronud some patch hunks
around to be the most logical with respect to the COLLAPSE RANGE, and
I must have dropped the fixup somewhere along the way).

Thanks for finding it!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
