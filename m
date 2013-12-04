From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/1] ext4: Try to better reuse recently freed space
Date: Wed, 4 Dec 2013 00:21:19 -0500
Message-ID: <20131204052119.GD15658@thunk.org>
References: <alpine.LFD.2.00.1312021727150.2284@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36294 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3LDFVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Dec 2013 00:21:23 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1312021727150.2284@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 02, 2013 at 05:32:06PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Hi all,
>=20
> this is the patch I send a while ago to fix the issue I've seen with
> a global allocation goal. This might no longer apply to the current
> kernel and it might not be the best approach, but I use this example
> just to start a discussion about those allocation goals and how to
> use, or change them.
>=20
> I think that we agree that the long term fix would be to have free
> extent map. But we might be able to do something quickly, unless
> someone commits to make the free extent map reality :)

There was discussion from the previous thread here:

      http://patchwork.ozlabs.org/patch/257476/


Looking at this, I think the patch makes sense, but I think it would
be good if we started thinking about what would be some good
benchmarks so we can measure and compare various different allocation
strategies.

Part of it would certainly be how long it takes to write or fallocate
the files, but also how how fragmented the files are.  Some indication
about how friendly the file system is to flash and thin-provisioned
systems.  (Where re-using blocks sooner rather than later might be
helpful if the user is only running fstrim once a week or some such.)

	       	       	    	    	   	- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
