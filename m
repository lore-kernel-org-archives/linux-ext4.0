From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Sun, 30 Aug 2009 05:48:52 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908300530300.6822@asgard.lang.hm>
References: <4A92F6FC.4060907@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <20090826122813.GI32712@mit.edu> <200908270106.15032.rob@landley.net> <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm> <20090830071957.GA1656@ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Rob Landley <rob@landley.net>, Theodore Tso <tytso@mit.edu>,
	Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090830071957.GA1656@ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 30 Aug 2009, Pavel Machek wrote:

>>> I thought the reason for that was that if your metadata is horked, further
>>> writes to the disk can trash unrelated existing data because it's lost track
>>> of what's allocated and what isn't.  So back when the assumption was "what's
>>> written stays written", then keeping the metadata sane was still darn
>>> important to prevent normal operation from overwriting unrelated existing
>>> data.
>>>
>>> Then Pavel notified us of a situation where interrupted writes to the disk can
>>> trash unrelated existing data _anyway_, because the flash block size on the 16
>>> gig flash key I bought retail at Fry's is 2 megabytes, and the filesystem thinks
>>> it's 4k or smaller.  It seems like what _broke_ was the assumption that the
>>> filesystem block size >= the disk block size, and nobody noticed for a while.
>>> (Except the people making jffs2 and friends, anyway.)
>>>
>>> Today we have cheap plentiful USB keys that act like hard drives, except that
>>> their write block size isn't remotely the same as hard drives', but they
>>> pretend it is, and then the block wear levelling algorithms fuzz things
>>> further.  (Gee, a drive controller lying about drive geometry, the scsi crowd
>>> should feel right at home.)
>>
>> actually, you don't know if your USB key works that way or not. Pavel has
>> ssome that do, that doesn't mean that all flash drives do
>>
>> when you do a write to a flash drive you have to do the following items
>>
>> 1. allocate an empty eraseblock to put the data on
>>
>> 2. read the old eraseblock
>>
>> 3. merge the incoming write to the eraseblock
>>
>> 4. write the updated data to the flash
>>
>> 5. update the flash trnslation layer to point reads at the new location
>> instead of the old location.
>
>
> That would need two erases per single sector writen, no? Erase is in
> milisecond range, so the performance would be just way too bad :-(.

no, it only needs one erase

if you don't have a pool of pre-erased blocks, then you need to do an 
erase of the new block you are allocating (before step 4)

if you do have a pool of pre-erased blocks, then you don't have to do any 
erase of the data blocks until after step 5 and you do the erase when you 
add the old data block to the pool of pre-erased blocks later.

in either case the requirements of wear leveling require that the flash 
translation layer update it's records to show that an additional write 
took place.

what appears to be happening on some cheap devices is that they do the 
following instead

1. allocate an empty eraseblock to put the data on

2. read the old eraseblock

3. merge the incoming write to the eraseblock

4. erase the old eraseblock

5. write the updated data to the flash

I don't know where in (or after) this process theyupdate the 
wear-levling/flash translation layer info.

with this algortihm, if the device looses power between step 4 and step 5 
you loose all the data on the eraseblock.

with deferred erasing of blocks, the safer algortihm is actually the 
faster one (up until you run out of your pool of available eraseblocks, at 
which time it slows down to the same speed as the unreliable one.

most flash drives are fairly slow to write to in any case.

even the Intel X25M drives are in the same ballpark as rotating media for 
writes. as far as I know only the X25E SSD drives are faster to write to 
than rotating media, and most of them are _far_ slower.

David Lang
