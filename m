From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 20:22:41 +0100
Message-ID: <20070729192241.GA14530@infradead.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org> <20070729173035.GU5992@schatzie.adilger.int> <46ACD2DA.20101@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49444 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765514AbXG2TWu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2007 15:22:50 -0400
Content-Disposition: inline
In-Reply-To: <46ACD2DA.20101@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 29, 2007 at 09:48:10PM +0400, Alex Tomas wrote:
> I think the latter one is better because it supports bs < pagesize
> (though I'm not sure about data=ordered yet). I'm not against putting
> most of the patch into fs/ext4/, but at least few bits to be changed
> in fs/ - exports in  fs/mpage.c and one "if" in __block_write_full_page().

The changes to __block_write_full_page is obviously fine, and exporting
mpage.c bits sounds fine to me aswell, although I'd like to take a look
at the final patch.
