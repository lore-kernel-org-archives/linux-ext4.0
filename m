From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Sat, 29 Aug 2009 07:28:21 -0400
Message-ID: <4A9910D5.4060208@redhat.com>
References: <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com> <20090826111208.GA26595@elf.ucw.cz> <alpine.DEB.2.00.0908260416270.30426@asgard.lang.hm> <20090829094919.GF1634@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090829094919.GF1634@ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/29/2009 05:49 AM, Pavel Machek wrote:
>    
>>> So instead of fixing or at least documenting known software deficiency
>>> in Linux MD stack, you'll try to surpress that information so that
>>> people use more of raid5 setups?
>>>
>>> Perhaps the better documentation will push them to RAID1, or maybe
>>> make them buy an UPS?
>>>        
>> people aren't objecting to better documentation, they are objecting to
>> misleading documentation.
>>      
> Actually Ric is. He's trying hard to make RAID5 look better than it
> really is.
>
>    
>

I object to misleading and dangerous documentation that you have 
proposed. I spend a lot of time working in data integrity, talking and 
writing about it so I care deeply that we don't misinform people.

In this thread, I put out a draft that is accurate several times and you 
have failed to respond to it.

The big picture that you don't agree with is:

(1) RAID (specifically MD RAID) will dramatically improve data integrity 
for real users. This is not a statement of opinion, this is a statement 
of fact that has been shown to be true in large scale deployments with 
commodity hardware.

(2) RAID5 protects you against a single failure and your test case 
purposely injects a double failure.

(3) How to configure MD reliably should be documented in MD 
documentation, not in each possible FS or raw device application

(4) Data loss occurs in non-journalling file systems and journalling 
file systems when you suffer double failures or hot unplug storage, 
especially inexpensive FLASH parts.

ric



