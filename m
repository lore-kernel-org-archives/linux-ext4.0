From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Tue, 25 Aug 2009 16:48:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908251647040.28411@asgard.lang.hm>
References: <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <4A93E908.6050908@redhat.com> <20090825211515.GA3688@elf.ucw.cz>
 <4A9468E8.607@redhat.com> <20090825225114.GE4300@elf.ucw.cz> <4A946DD1.8090906@redhat.com> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A947682.2010204@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 25 Aug 2009, Ric Wheeler wrote:

> On 08/25/2009 07:26 PM, Pavel Machek wrote:
>> 
>>>>> Basically, any file system (Linux, windows, OSX, etc) that writes into
>>>>> the page cache will lose data when you hot unplug its storage. End of
>>>>> story, don't do it!
>>>> 
>>>> No, not ext3 on SATA disk with barriers on and proper use of
>>>> fsync(). I actually tested that.
>>>> 
>>>> Yes, I should be able to hotunplug SATA drives and expect the data
>>>> that was fsync-ed to be there.
>>> 
>>> You can and will lose data (even after fsync) with any type of storage at
>>> some rate. What you are missing here is that data loss needs to be
>>> measured in hard numbers - say percentage of installed boxes that have
>>> config X that lose data.
>> 
>> I'm talking "by design" here.
>> 
>> I will lose data even on SATA drive that is properly powered on if I
>> wait 5 years.
>> 
>
> You are dead wrong.
>
> For RAID5 arrays, you assume that you have a hard failure and a power outage 
> before you can rebuild the RAID (order of hours at full tilt).

and that the power outage causes a corrupted write.

>>> I can promise you that hot unplugging and replugging a S-ATA drive will
>>> also lose you data if you are actively writing to it (ext2, 3, whatever).
>> 
>> I can promise you that running S-ATA drive will also lose you data,
>> even if you are not actively writing to it. Just wait 10 years; so
>> what is your point?
>
> I lost a s-ata drive 24 hours after installing it in a new box. If I had MD5 
> RAID5, I would not have lost any.

me to, in fact just after I copied data from a raid array to it so that I 
could rebuild the raid array differently :-(

David Lang
