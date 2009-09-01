From: david@lang.hm
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Tue, 1 Sep 2009 08:25:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0909010825000.6822@asgard.lang.hm>
References: <20090901111803.11027.qmail@science.horizon.com> <e57f474f060bf2a16437b16aac23fabd.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: George Spelvin <linux@horizon.com>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz
To: NeilBrown <neilb@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <e57f474f060bf2a16437b16aac23fabd.squirrel@neil.brown.name>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 1 Sep 2009, NeilBrown wrote:

> On Tue, September 1, 2009 9:18 pm, George Spelvin wrote:
>>>> An embedded checksum, no matter how good, can't tell you if
>>>> the data is stale; you need a way to distinguish versions in the
>>>> pointer.
>>
>>> I would disagree with that.
>>> If the embedded checksum is a function of both the data and the address
>>> of the data (in whatever address space seems most appropriate) then it
>>> can
>>> still verify that the data found with the checksum is the data that was
>>> expected.
>>> And storing the checksum with the data (where it is practical) means
>>> index blocks can be more dense so on average fewer accesses to storage
>>> are needed.
>>
>> I must not have been clear.  Originally, block 100 has contents version 1.
>> This includes a correctly computed checksum.
>>
>> Then you write version 2 of the data there.  But there's a bit error in
>> the address and the write goes to block 256+100 = 356.  So block
>> 100 still has the version 1 contents, complete with valid checksum.
>> (Yes, block 356 is now corrupted, but perhaps it's not even allocated.)
>>
>> Then we go to read block 100, find a valid checksum, and return incorrect
>> data.  Namely, version 1 data, when we expact and want version 2.
>>
>> Basically, the pointer has to say which *version* of the data it points
>> to,
>> not just the block address.  Otherwise, it can't detect a missing write.
>
> Agreed.  I think the minimum is that the index block must be changed in
> some way whenever data that it points to is changed.  Exactly how
> depends very much of other details of the filesystem layout.
> For a copy-on-write filesystem where changed data is always written
> to a new location, this is very easy to achieve as the 'physical'
> address can probably be used as a version identifier in some way.
> For write-in-place you would need the version information
> to be more explicit as you say, whether a small version number
> or a larger hash of the data.

but then don't you have to update the version on the index (and therefor 
the pointer to that directory), on up to the point where you update the 
root?

David Lang
