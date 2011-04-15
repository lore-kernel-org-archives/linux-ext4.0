From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Fri, 15 Apr 2011 13:16:29 -0400
Message-ID: <20110415171629.GA9088@infradead.org>
References: <20110414102608.GA1678@x4.trippels.de>
 <20110414120635.GB1678@x4.trippels.de>
 <20110414140222.GB1679@x4.trippels.de>
 <4DA70BD3.1070409@draigBrady.com>
 <4DA717B2.3020305@sandeen.net>
 <20110414225904.GK21395@dastard>
 <4DA7836A.5040604@draigBrady.com>
 <20110415000940.GL21395@dastard>
 <87sjtjq4ir.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	P?draig Brady <P@draigBrady.com>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@sandeen.net>, coreutils@gnu.org,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1DORQf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2011 13:16:35 -0400
Content-Disposition: inline
In-Reply-To: <87sjtjq4ir.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 15, 2011 at 10:53:48AM +0200, Jim Meyering wrote:
> Can you or anyone else point to authoritative documentation
> (or even a summary of those "discussions") of FIEMAP semantics?

A large part of the problem is that there's none and the semantics
is a hode-podge of random flags that mostly make little sense
outside of fs developers debugging the layout that we created.  The
closest to a description is Documentation/filesystems/fiemap.txt
in the kernel tree, but that doesn't document most of the delicate
points.

