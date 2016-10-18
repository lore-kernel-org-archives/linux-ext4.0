From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/28] ext2: avoid bogus -Wmaybe-uninitialized warning
Date: Tue, 18 Oct 2016 11:30:18 +0200
Message-ID: <20161018093018.GK3359@quack2.suse.cz>
References: <20161017220342.1627073-1-arnd@arndb.de>
 <20161017220557.1688282-5-arnd@arndb.de>
 <20161018051529.GA24233@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>,
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
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161018051529.GA24233@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 17-10-16 22:15:29, Christoph Hellwig wrote:
> Thanks Arnd, this looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks! I have pulled the patch into my tree and will push it to Linus.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
