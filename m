From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Date: Thu, 4 Sep 2014 23:17:35 -0400
Message-ID: <20140905031735.GD1971@thunk.org>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
 <20140905014808.GA26070@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, gunho.lee@lge.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140905014808.GA26070@js1304-P5Q-DELUXE>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Joonson,

Thanks for the update.  I've applied Gioh's patches to the ext4 tree,
but I'd appreciate a further clarification.  My understanding with the
problem you were trying to address is that with the current CMA
implementation, kswapd was getting activiated too early, yes?

But it would still be a good idea to try to use non-moveable memory in
preference in favor of CMA memory; even if the page migration can move
the contents of the page elsewhere, wouldn't be better to avoid
needing to do the page migation in the first place.  Given that the
ext4 file systems are getting mounted very early in the boot process,
when there should be plenty of CMA and non-CMA elegible memory
available, why was CMA memory getting selected for the buffer cache
allocations when non-CMA memory available?

In other words, even without Gioh's patch to force the use of non-CMA
eligible memory, wouldn't it be better if the memory allocator used
non-CMA preferentially if it were available.  This should be
orthogonal to whether or not kswaped gets activiated, right?

Regards,

							- Ted
