From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 15 Nov 2009 17:11:46 -0500
Message-ID: <20091115221146.GH4323@mit.edu>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de> <4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de> <4B00730F.5060503@redhat.com> <4B0076AD.9020008@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42629 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbZKOWLo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 17:11:44 -0500
Content-Disposition: inline
In-Reply-To: <4B0076AD.9020008@diamondcut.com.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 15, 2009 at 07:46:21PM -0200, Renato S. Yamane wrote:
> On 15-11-2009 19:30, Eric Sandeen wrote:
>> Florian Weimer wrote:
>>> * Renato S. Yamane:
>>>> How can I know the average writes per day?
>>>
>>> I used iostat (part of sysstat). Perhaps I should have checked first
>>> if it is accurate. 8-/
>>
>> If you're running ext4, you can look at:
>> /sys/fs/ext4/sdXX/lifetime_write_kbytes and
>> /sys/fs/ext4/sdXX/session_write_kbytes
>
> smartctl show me 229h Power_On_Hours (I buy it one month ago).
> And /sys/fs/ext4/sdXX/lifetime_write_kbytes show me 19940467
>
> So:
> 229h = 9,54 days
> 19940467 kbytes / 9,54 days = 2Gb/day
>
> I think that it is too much. I use it on my laptop only to see my  
> e-mails (Thunderbird) and use OpenOffice.org on my work environment.

If you've only had the disk for a short while, then the initial writes
to install your system is probably biasing your results.  So far you
have approximately 19GB of disk writes.  I'm guessing that at least
3-4GB is from the initial installation of software on your system.

Also, if you are turning off your laptop at night, treating 229 hours
as 9.5 days isn't really fair.  If you installed the SSD a month ago,
then treat that as 30 days, and we get:

     16GB / 30 == 0.533 GB

This is well under the rated 20GB/day upon which Intel guarantees a
five year life --- and most people don't keep their laptop and/or hard
drives that long anyway.

						- Ted
