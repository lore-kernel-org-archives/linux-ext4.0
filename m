From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sat, 28 Jul 2007 20:57:14 +0100
Message-ID: <20070728195714.GD5952@infradead.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9E754.5070904@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34973 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbXG1T5S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Jul 2007 15:57:18 -0400
Content-Disposition: inline
In-Reply-To: <46A9E754.5070904@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2007 at 04:38:44PM +0400, Alex Tomas wrote:
> I just realized that you're talking about data=ordered mode in ext4,
> where care is taken to prevent on-disk references to no-yet-written
> blocks.

Any reference to non-written blocks is a bug.
