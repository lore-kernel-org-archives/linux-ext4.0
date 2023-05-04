Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A83FC77B7C
	for <linux-ext4@archiver.kernel.org>; Thu,  4 May 2023 16:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjEDQVb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 May 2023 12:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjEDQVa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 May 2023 12:21:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC84359D;
        Thu,  4 May 2023 09:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xNrzahxisfy2D9GpQQsapIsOxx/6hZf8YuSTxd9nEBY=; b=J7o12dUjGzezKJVUFDeEK+Nek0
        4w32+t1wCykosSCQC6rewjDWwiIgAg5Qh0Nd31+tuHIhLO1gpKusbtv1rE/441rV0fTLMIguJZPqo
        Iw+gTf3HFt35Vd8FErSCxs4nNyq9Vl1HbUCMKefkQQLy9wy/95/uDVmarQlH6d/2EQ+HPWpEmNnx7
        xLbJEFS2WdmXvL45AESlq1++dKlG/A282LMCjOtk0v7esTFbfuU9w8iUdHvFs/MU8vH77vv02/V3o
        GMpongEetngPUmWTBGa73s15SfqNBYOaMWXfBGUbCgUHbOafCbfHoLceQ1Ml8jwI0ZlkUWCPQbCfC
        59WsA6ig==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pubhq-00Akte-9Y; Thu, 04 May 2023 16:21:22 +0000
Date:   Thu, 4 May 2023 17:21:22 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-block@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Zhang Yi <yi.zhang@redhat.com>
Subject: Re: [ext4 io hang] buffered write io hang in balance_dirty_pages
Message-ID: <ZFPbgn4r7fX6liko@casper.infradead.org>
References: <ZEnb7KuOWmu5P+V9@ovpn-8-24.pek2.redhat.com>
 <ZFPWeOg5xJ7CbCD0@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFPWeOg5xJ7CbCD0@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 04, 2023 at 09:59:52AM -0600, Keith Busch wrote:
> On Thu, Apr 27, 2023 at 10:20:28AM +0800, Ming Lei wrote:
> > Hello Guys,
> > 
> > I got one report in which buffered write IO hangs in balance_dirty_pages,
> > after one nvme block device is unplugged physically, then umount can't
> > succeed.
> > 
> > Turns out it is one long-term issue, and it can be triggered at least
> > since v5.14 until the latest v6.3.
> > 
> > And the issue can be reproduced reliably in KVM guest:
> > 
> > 1) run the following script inside guest:
> > 
> > mkfs.ext4 -F /dev/nvme0n1
> > mount /dev/nvme0n1 /mnt
> > dd if=/dev/zero of=/mnt/z.img&
> > sleep 10
> > echo 1 > /sys/block/nvme0n1/device/device/remove
> > 
> > 2) dd hang is observed and /dev/nvme0n1 is gone actually
> 
> Sorry to jump in so late.
> 
> For an ungraceful nvme removal, like a surpirse hot unplug, the driver
> sets the capacity to 0 and that effectively ends all dirty page writers
> that could stall forward progress on the removal. And that 0 capacity
> should also cause 'dd' to exit.
> 
> But this is not an ungraceful removal, so we're not getting that forced
> behavior. Could we use the same capacity trick here after flushing any
> outstanding dirty pages?

There's a filesystem mounted on that block device, though.  I don't
think the filesystem is going to notice the underlying block device
capacity change and break out of any of these functions.
