From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Mon, 26 May 2014 12:50:10 -0400
Message-ID: <20140526165010.GN22284@thunk.org>
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
Received: from imap.thunk.org ([74.207.234.97]:33218 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaEZQuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 12:50:14 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 06:54:05PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Yes it tries to align down the start_off of the bigger requests to th=
e 512,
> 1024, 2048, or 4096 respectively. What the reason for it is really I =
have
> no idea. The fact is however that this will only affect file systems
> with bs smaller than 4k since the start_off will be always aligned to
> block size afterwards (obviously).
>=20
> That said this alignment is only done when the request is "big
> enough". With your change we also do it when the block group is
> "small enough" which is the change in behaviour which I think was
> not really intended.
>=20
> Honestly I do not think this really matters a lot but this alignment
> you've added is not necessary.
>=20
> All that said, I was getting to rewrite this mess a long time ago,
> it's just a reminder that it's something that needs to be done.
> Especially since the bigger requests are getting split unnecessarily
> which hurts especially in fallocate case.

Hey Lukas, where are we with respect to your plans to fix up this
code?

I'm trying to figure out what we should do with Maurizio's bug fix.
Should we apply it even though it's making some changes to the
existing behavior.

As far as to why the existing code is trying to align the starting
offset to a power of two, I believe the idea is to avoid
fragmentation, since the normalize_request function will tend to round
up allocaiton requests to the same power of two.

   	      	       	      	   	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
