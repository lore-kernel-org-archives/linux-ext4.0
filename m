From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/28] ext2: avoid bogus -Wmaybe-uninitialized warning
Date: Mon, 17 Oct 2016 22:15:29 -0700
Message-ID: <20161018051529.GA24233@infradead.org>
References: <20161017220342.1627073-1-arnd@arndb.de>
 <20161017220557.1688282-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755736AbcJRFPf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Oct 2016 01:15:35 -0400
Content-Disposition: inline
In-Reply-To: <20161017220557.1688282-5-arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Arnd, this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
