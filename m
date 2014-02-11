From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Tue, 11 Feb 2014 11:47:10 -0700
Message-ID: <52FA702E.7020503@hp.com>
References: <20140128122623.26029.qmail@science.horizon.com> <848E47EB-5FDF-4DB9-9800-4B1F4B1FA71C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, Andi Kleen <andi@firstfloor.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>,
	George Spelvin <linux@horizon.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <848E47EB-5FDF-4DB9-9800-4B1F4B1FA71C@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/28/2014 02:09 PM, Andreas Dilger wrote:
> On Jan 28, 2014, at 5:26 AM, George Spelvin <linux@horizon.com> wrote:
>>> The third part of the patch further increases the scalablity of an ext4
>>> filesystem by having each ext4 fielsystem allocate and use its own private
>>> mbcache structure, instead of sharing a single mcache structures across all
>>> ext4 filesystems, and increases the size of its mbcache hash tables.
>>
>> Are you sure this helps?  The idea behind having one large mbcache is
>> that one large hash table will always be at least as well balanced as
>> multiple separate tables, if the total size is the same.
>>
>> If you have two size 2^n hash tables, the chance of collision is equal to
>> one size  2^(n+1) table if they're equally busy, and if they're unequally
>> busy. the latter is better.  The busier file system will take less time
>> per search, and since it's searched more often than the less-busy one,
>> net win.
>>
>> How does it compare with just increasing the hash table size but leaving
>> them combined?
> 
> Except that having one mbcache per block device would avoid the need
> to store the e_bdev pointer in thousands/millions of entries.  Since
> the blocks are never shared between different block devices, there
> is no caching benefit even if the same block is on two block devices.
> 
> Cheers, Andreas
> 

On all 3 systems, with 80, 60 and 20 cores, that I ran aim7 on, spreading test files across 4 ext4 filesystems, there seems to be no different in performance either with a single large hash table or a smaller one per filesystem.

Having said that, I still believe that having a separate hash table for each filesystem should scale better, as the size of a larger single hash table would be very arbitrary. As Andres mentioned above, with an mbcache per filesystem we would be able to remove the e_bdev member from the mb_cache_entry. It would also work well and also result in less mb_cache_entry lock contention, if we are to use the blockgroup locks, which are also on a per filesystem base, to implement the mb_cache_entry lock as suggested by Andreas.  

Please let me know if you have any further comment or concerns.

Thanks,
Mak.

 

