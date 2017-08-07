From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Mon, 7 Aug 2017 14:12:12 +0200
Message-ID: <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753024AbdHGMMQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Aug 2017 08:12:16 -0400
Content-Disposition: inline
In-Reply-To: <20170805084601.GA12425@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 05, 2017 at 01:46:01AM -0700, Christoph Hellwig wrote:
> Please don't do this until we have a coherent DAX plan.  So far
> the flag in XFS seems like a massive mistake and we need to get
> rid of it instead of adding it to more file systems.

Hi, pardon my ignorance, but can you point me to the discussion where
this was decided ? I must have missed it and I can't find it.

Thanks!
-Lukas
