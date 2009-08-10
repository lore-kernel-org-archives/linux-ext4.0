From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
Date: Mon, 10 Aug 2009 12:09:49 -0400
Message-ID: <20090810160949.GA21948@infradead.org>
References: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com> <4A80291D.6020200@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lachlan McIlroy <lmcilroy@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbZHJQJt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 12:09:49 -0400
Content-Disposition: inline
In-Reply-To: <4A80291D.6020200@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 10, 2009 at 09:05:17AM -0500, Eric Sandeen wrote:
> Lachlan McIlroy wrote:
> > This looks good Eric.
> > 
> > Is this test just for quota accounting or should it be testing quota
> > enforcement too?
> 
> I guess 108 just did accounting; I was going to keep it parallel, and do
> a different one for accounting, but it could be added to this as well.

Yeah, let's use a different one for enforement testing.

