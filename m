From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in punch_hole
Date: Wed, 19 Jun 2013 19:42:43 -0400
Message-ID: <20130619234243.GE24587@thunk.org>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <1368549454-8930-16-git-send-email-lczerner@redhat.com>
 <20130614030154.GA18731@thunk.org>
 <alpine.LFD.2.00.1306191831210.2085@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashishsangwan2@gmail.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59560 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSXmq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Jun 2013 19:42:46 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1306191831210.2085@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 19, 2013 at 06:37:53PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I think I've got this. The problem actually is in
> ext4_zero_partial_blocks() where we would attempt to zero out page
> which has been previously released by truncate_pagecache_range().
> This might happen when we're punching out just a single page because
> in ext4_zero_partial_blocks() we do not check whether we're dealing
> with the whole, or partial page. At the point we're going to zero it
> out it might have been already released and reused by someone else.
>=20
> This patch should fix this issue. And indeed with this applied I do
> not see the problem anymore but I am still testing.

Thanks for finding this!  I'm still doing testing of your trial patch
myself, but initial results seem to indicate that this also solves the
failures 269 and 270 which was apparently uncovered by Ashish's patch
"ext4: optimize extent selection for block removal in case of hole
punch".

	 		      	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
