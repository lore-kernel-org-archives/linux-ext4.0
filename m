From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Fri, 24 Jan 2014 23:09:24 -0700
Message-ID: <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
References: <1377186876-57291-1-git-send-email-tmac@hp.com> <1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: T Makphaibulchoke <tmac@hp.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"aswin@hp.com" <aswin@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87fvodcb65.fsf@tassilo.jf.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I think the ext4 block groups are locked with the blockgroup_lock that has about the same number of locks as the number of cores, with a max of 128, IIRC.  See blockgroup_lock.h. 

While there is some chance of contention, it is also unlikely that all of the cores are locking this area at the same time.  

Cheers, Andreas

> On Jan 24, 2014, at 14:38, Andi Kleen <andi@firstfloor.org> wrote:
> 
> T Makphaibulchoke <tmac@hp.com> writes:
> 
>> The patch consists of three parts.
>> 
>> The first part changes the implementation of both the block and hash chains of
>> an mb_cache from list_head to hlist_bl_head and also introduces new members,
>> including a spinlock to mb_cache_entry, as required by the second part.
> 
> spinlock per entry is usually overkill for larger hash tables.
> 
> Can you use a second smaller lock table that just has locks and is 
> indexed by a subset of the hash key. Most likely a very small 
> table is good enough.
> 
> Also I would be good to have some data on the additional memory consumption.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only
