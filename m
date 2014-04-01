From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/1] ext4: Try to better reuse recently freed space
Date: Tue, 1 Apr 2014 01:30:18 -0400
Message-ID: <20140401053018.GP4911@thunk.org>
References: <alpine.LFD.2.00.1312021727150.2284@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48169 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaDAFaW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Apr 2014 01:30:22 -0400
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

Hi Andreas,

We discussed possibly applying this patch last week at the ext4
workshop, possibly as early as for the 3.15 merge window:

	http://patchwork.ozlabs.org/patch/295956/

However, I'm guessing that Lustre has the workload which is most
likely to regress if we were to simply apply this patch.  But, it's
likely it will improve things for many/most other ext4 workloads.

We did talk about trying to assemble some block allocation performance
tests so we can better measure proposed changes to the block
allocator, but that's not something we have yet.  However, this global
goal is definitely causing problems for a number of use cases,
including thinp and being flash friendly.

Would you be willing to apply this patch and then run some benchmarks
to see if Lustre would be impacted negatively if we were to apply this
patch for the next development cycle (i.e., not for 3.15, but for the
next merge window)?

Thanks,

							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
