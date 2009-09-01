From: "NeilBrown" <neilb@suse.de>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Wed, 2 Sep 2009 07:12:17 +1000 (EST)
Message-ID: <b9c30a520f952638373bb37bc8e2aec6.squirrel@neil.brown.name>
References: <20090901111803.11027.qmail@science.horizon.com>
    <e57f474f060bf2a16437b16aac23fabd.squirrel@neil.brown.name>
    <alpine.DEB.2.00.0909010825000.6822@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "George Spelvin" <linux@horizon.com>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz
To: david@lang.hm
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZIAVPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 17:15:07 -0400
In-Reply-To: <alpine.DEB.2.00.0909010825000.6822@asgard.lang.hm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, September 2, 2009 1:25 am, david@lang.hm wrote:
> On Tue, 1 Sep 2009, NeilBrown wrote:
>
>> On Tue, September 1, 2009 9:18 pm, George Spelvin wrote:
>>>>> An embedded checksum, no matter how good, can't tell you if
>>>>> the data is stale; you need a way to distinguish versions in the
>>>>> pointer.
>>>
>>>> I would disagree with that.
>>>> If the embedded checksum is a function of both the data and the
>>>> address
>>>> of the data (in whatever address space seems most appropriate) then it
>>>> can
>>>> still verify that the data found with the checksum is the data that
>>>> was
>>>> expected.
>>>> And storing the checksum with the data (where it is practical) means
>>>> index blocks can be more dense so on average fewer accesses to storage
>>>> are needed.
>>>
>>> I must not have been clear.  Originally, block 100 has contents version
>>> 1.
>>> This includes a correctly computed checksum.
>>>
>>> Then you write version 2 of the data there.  But there's a bit error in
>>> the address and the write goes to block 256+100 = 356.  So block
>>> 100 still has the version 1 contents, complete with valid checksum.
>>> (Yes, block 356 is now corrupted, but perhaps it's not even allocated.)
>>>
>>> Then we go to read block 100, find a valid checksum, and return
>>> incorrect
>>> data.  Namely, version 1 data, when we expact and want version 2.
>>>
>>> Basically, the pointer has to say which *version* of the data it points
>>> to,
>>> not just the block address.  Otherwise, it can't detect a missing
>>> write.
>>
>> Agreed.  I think the minimum is that the index block must be changed in
>> some way whenever data that it points to is changed.  Exactly how
>> depends very much of other details of the filesystem layout.
>> For a copy-on-write filesystem where changed data is always written
>> to a new location, this is very easy to achieve as the 'physical'
>> address can probably be used as a version identifier in some way.
>> For write-in-place you would need the version information
>> to be more explicit as you say, whether a small version number
>> or a larger hash of the data.
>
> but then don't you have to update the version on the index (and therefor
> the pointer to that directory), on up to the point where you update the
> root?

Yes, all the way to the root.  This is true no matter what data verification
scheme you use, if you want to be able to detect silently failing writes.
This makes it a very neat fit for copy-on-write designs, which have to do
that anyway, and a more awkward fit for update-in-place designs.

NeilBrown

