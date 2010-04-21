From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 16:01:29 -0500
Message-ID: <4BCF67A9.2040902@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <1271674527-2977-2-git-send-email-lczerner@redhat.com>	 <1271674527-2977-3-git-send-email-lczerner@redhat.com>	 <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>	 <4BCF4C53.3010608@redhat.com>	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com> <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Moyer <jmoyer@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Edward Shishkin <eshishki@redhat.com>,
	Christoph Hellwig <hch@ifradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0DUVBd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 17:01:33 -0400
In-Reply-To: <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/21/2010 03:44 PM, Greg Freemyer wrote:

> Mark's benchmarks showed this as doable in seconds which seems like a
> reasonable amount of time for a mount time operation.

All the other things aside, mount-time is interesting, but it's an
infrequent operation, at least in my world.  I think we need something
that can be done runtime.

For anything with uptime, I don't think it's acceptable to wait until
the next mount to trim unused blocks.

But as long as the mechanism can be called either at mount time and/or
kicked off runtime somehow, I'm happy.

-Eric
