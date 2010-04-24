From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 14:39:22 -0400
Message-ID: <yq11ve4g0f9.fsf@sermon.lab.mkp.net>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	<1271674527-2977-3-git-send-email-lczerner@redhat.com>
	<r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
	<4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
	<v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
	<4BCF4C53.3010608@redhat.com>
	<x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
	<k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
	<alpine.LFD.2.00.1004230944070.2814@localhost>
	<w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:65425 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0DXSkt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Apr 2010 14:40:49 -0400
In-Reply-To: <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>
	(Greg Freemyer's message of "Sat, 24 Apr 2010 09:24:09 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> That may mean the topology information needs to grow some discard
Greg> info.  Does anyone know if that info is easily derived from the
Greg> currently existing topo info?

The values are already part of the topology information (assuming the
device reports them).  Went into 2.6.33.

-- 
Martin K. Petersen	Oracle Linux Engineering
