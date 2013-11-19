From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [BUG] ext2/3/4: dio reads stale data when we do some append dio
 writes
Date: Tue, 19 Nov 2013 18:45:08 +0800
Message-ID: <20131119104508.GA4630@gmail.com>
References: <20131119095302.GA4534@gmail.com>
 <20131119102235.GA5010@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48887 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3KSKm1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 05:42:27 -0500
Content-Disposition: inline
In-Reply-To: <20131119102235.GA5010@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 19, 2013 at 02:22:35AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 19, 2013 at 05:53:03PM +0800, Zheng Liu wrote:
> > code snippet:
> 
> Can you please wire this up as a regression test for xfstests?
> 

No problem.  I am happy to do that.

BTW, that would be great if you could give me some comments about this
problem itself.  Is it a generic problem in vfs?  Or just a feature by
design?

Thanks,
                                                - Zheng
