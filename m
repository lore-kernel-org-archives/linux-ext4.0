From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Fri, 24 Jan 2014 13:38:58 -0800
Message-ID: <87fvodcb65.fsf@tassilo.jf.intel.com>
References: <1377186876-57291-1-git-send-email-tmac@hp.com>
	<1390588288-66930-1-git-send-email-tmac@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, aswin@hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1390588288-66930-1-git-send-email-tmac@hp.com>
	(T. Makphaibulchoke's message of "Fri, 24 Jan 2014 11:31:25 -0700")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

T Makphaibulchoke <tmac@hp.com> writes:

> The patch consists of three parts.
>
> The first part changes the implementation of both the block and hash chains of
> an mb_cache from list_head to hlist_bl_head and also introduces new members,
> including a spinlock to mb_cache_entry, as required by the second part.

spinlock per entry is usually overkill for larger hash tables.

Can you use a second smaller lock table that just has locks and is 
indexed by a subset of the hash key. Most likely a very small 
table is good enough.

Also I would be good to have some data on the additional memory consumption.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
