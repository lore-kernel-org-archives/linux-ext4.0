From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 13:26:03 -0400
Message-ID: <20110415172603.GA20086@infradead.org>
References: <20110414120635.GB1678@x4.trippels.de>
 <20110414140222.GB1679@x4.trippels.de>
 <4DA70BD3.1070409@draigBrady.com>
 <4DA717B2.3020305@sandeen.net>
 <20110414225904.GK21395@dastard>
 <4DA7836A.5040604@draigBrady.com>
 <20110415000940.GL21395@dastard>
 <87sjtjq4ir.fsf@rho.meyering.net>
 <20110415171629.GA9088@infradead.org>
 <4DA87F43.5040807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Jim Meyering <jim@meyering.net>,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>,
	coreutils@gnu.org, linux-ext4@vger.kernel.org,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Eric Blake <eblake@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1DOR0H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2011 13:26:07 -0400
Content-Disposition: inline
In-Reply-To: <4DA87F43.5040807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 15, 2011 at 11:24:19AM -0600, Eric Blake wrote:
> Would it be worth borrowing from Solaris' semantics and adding SEEK_HOLE
> and SEEK_DATA to lseek(2), as a higher level (less-detailed, but easier
> to define and easier to use) interface for discovering the regions of a
> file that only contain NUL bytes?

Yes, I've already suggested that both in this thread and on IRC.

For efficient copies it's the only usable interface.
