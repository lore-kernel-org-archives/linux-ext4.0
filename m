From: Lachlan McIlroy <lmcilroy@redhat.com>
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
Date: Mon, 10 Aug 2009 21:59:45 -0400 (EDT)
Message-ID: <669295477.1736351249955985378.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <20090810160949.GA21948@infradead.org>
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZHKCA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Aug 2009 22:00:56 -0400
In-Reply-To: <20090810160949.GA21948@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- "Christoph Hellwig" <hch@infradead.org> wrote:

> On Mon, Aug 10, 2009 at 09:05:17AM -0500, Eric Sandeen wrote:
> > Lachlan McIlroy wrote:
> > > This looks good Eric.
> > > 
> > > Is this test just for quota accounting or should it be testing
> quota
> > > enforcement too?
> > 
> > I guess 108 just did accounting; I was going to keep it parallel,
> and do
> > a different one for accounting, but it could be added to this as
> well.
> 
> Yeah, let's use a different one for enforement testing.

Agree, if quota enforcement isn't working correctly then the accounting
is the first thing to check so having seperate tests is a good idea.
