From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 16:09:20 +0400
Message-ID: <46AC8370.8050308@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9A41C.7080104@clusterfs.com> <20070729091807.GF31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:53853 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbXG2MJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jul 2007 08:09:44 -0400
In-Reply-To: <20070729091807.GF31489@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

David Chinner wrote:
> On Fri, Jul 27, 2007 at 11:51:56AM +0400, Alex Tomas wrote:
> But this is really irrelevant - the issue at hand is what we want
> for VFS level delalloc support. IMO, that mechanism needs to support
> both XFS and ext4, and I'd prefer if it doesn't perpetuate the
> bufferhead abuses of the past (i.e. define an iomap structure
> instead of overloading bufferheads yet again).

I'm not sure I understand very well. where would you track uptodate,
dirty and other states then? do you propose to separate block states
from block mapping?

thanks, Alex
