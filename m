From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Sat, 05 Sep 2009 08:20:47 -0400
Message-ID: <4AA2579F.9010802@redhat.com>
References: <20090826001645.GN4300@elf.ucw.cz> <200909022141.48827.rob@landley.net> <4A9FCF53.10105@hp.com> <200909040244.54772.rob@landley.net> <4AA0FECE.3010200@redhat.com> <20090905102810.GA1341@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rob Landley <rob@landley.net>, jim owens <jowens@hp.com>,
	david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090905102810.GA1341@ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 09/05/2009 06:28 AM, Pavel Machek wrote:
> On Fri 2009-09-04 07:49:34, Ric Wheeler wrote:
>    
>> On 09/04/2009 03:44 AM, Rob Landley wrote:
>>      
>>> On Thursday 03 September 2009 09:14:43 jim owens wrote:
>>>
>>>        
>>>> Rob Landley wrote:
>>>>
>>>>          
>>>>> I think he understands he was clueless too, that's why he investigated
>>>>> the failure and wrote it up for posterity.
>>>>>
>>>>>
>>>>>            
>>>>>> And Ric said do not stigmatize whole classes of A) devices, B) raid,
>>>>>> and C) filesystems with "Pavel says...".
>>>>>>
>>>>>>              
>>>>> I don't care what "Pavel says", so you can leave the ad hominem at the
>>>>> door, thanks.
>>>>>
>>>>>            
>>>> See, this is exactly the problem we have with all the proposed
>>>> documentation.  The reader (you) did not get what the writer (me)
>>>> was trying to say.  That does not say either of us was wrong in
>>>> what we thought was meant, simply that we did not communicate.
>>>>
>>>>          
>>> That's why I've mostly stopped bothering with this thread.  I could respond to
>>> Ric Wheeler's latest (what does write barriers have to do with whether or not
>>> a multi-sector stripe is guaranteed to be atomically updated during a panic or
>>> power failure?) but there's just no point.
>>>
>>>        
>> The point of that post was that the failure that you and Pavel both
>> attribute to RAID and journalled fs happens whenever the storage cannot
>> promise to do atomic writes of a logical FS block (prevent torn
>> pages/split writes/etc). I gave a specific example of why this happens
>> even with simple, single disk systems.
>>      
> ext3 does not expect atomic write of 4K block, according to Ted. So
> no, it is not broken on single disk.
>    

I am not sure what you mean by "expect."

ext3 (and other file systems) certainly expect that acknowledged writes 
will still be there after a crash.

With your disk write cache on (and no working barriers or non-volatile 
write cache), this will always require a repair via fsck or leave you 
with corrupted data or metadata.

ext4, btrfs and zfs all do checksumming of writes, but this is a 
detection mechanism.

Repair of the partial write is done on detection (if you have another 
copy in btrfs or xfs) or by repair (ext4's fsck).

For what it's worth, this is the same story with databases (DB2, Oracle, 
etc). They spend a lot of energy trying to detect partial writes from 
the application level's point of view and their granularity is often 
multiple fs blocks....

>
>    
>>> The LWN article on the topic is out, and incomplete as it is I expect it's the
>>> best documentation anybody will actually _read_.
>>>        
> Would anyone (probably privately?) share the lwn link?
> 								Pavel
>    

