From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Thu, 26 Jul 2007 17:33:08 +0400
Message-ID: <46A8A294.2070106@clusterfs.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:63976 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbXGZNdd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jul 2007 09:33:33 -0400
In-Reply-To: <46A88DFD.7030609@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It duplicates fs/mpage.c in bio building and introduces new generic API
(iomap, map_blocks_t, etc). In contrast, my trivial implementation re-use
existing code in fs/mpage.c, doesn't introduce new API and I tend to think
provides quite the same functionality. I can be wrong, of course ...

thanks, Alex

Jeff Garzik wrote:
> The XFS one is proven and the work was already completed.
> 
> What were the specific technical issues that made it unsuitable for ext4?
> 
> I would rather not reinvent the wheel, particularly if the reinvention 
> is less capable than the existing work.
> 
>     Jeff
> 
> 
