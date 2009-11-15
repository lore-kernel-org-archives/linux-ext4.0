From: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 15 Nov 2009 20:18:16 -0200
Message-ID: <4B007E28.6050302@diamondcut.com.br>
References: <4AFC14D6.7080700@diamondcut.com.br> <20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de> <4B006F8A.8000606@diamondcut.com.br> <878we7v651.fsf@mid.deneb.enyo.de> <4B00730F.5060503@redhat.com> <4B0076AD.9020008@diamondcut.com.br> <20091115221146.GH4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Florian Weimer <fw@deneb.enyo.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-04.mandic.com.br ([200.225.81.151]:35717 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKOWSE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 17:18:04 -0500
Received: from 189.114.151.225.dynamic.adsl.gvt.net.br (HELO [192.168.1.104]) (4s3fxNW2pdTI28e3yZjKop5Ok6I=@[189.114.151.225])
          (envelope-sender <yamane@diamondcut.com.br>)
          by smtp-04.mandic.com.br (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-ext4@vger.kernel.org>; 15 Nov 2009 22:18:06 -0000
In-Reply-To: <20091115221146.GH4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 15-11-2009 20:11, Theodore Tso wrote:
> Renato S. Yamane wrote:
>> Eric Sandeen wrote:
>>> Florian Weimer wrote:
>>>> Renato S. Yamane wrote:
>>>>> How can I know the average writes per day?
>>>>
>>>> I used iostat (part of sysstat). Perhaps I should have checked first
>>>> if it is accurate. 8-/
>>>
>>> If you're running ext4, you can look at:
>>> /sys/fs/ext4/sdXX/lifetime_write_kbytes and
>>> /sys/fs/ext4/sdXX/session_write_kbytes
>>
>> smartctl show me 229h Power_On_Hours (I buy it one month ago).
>> And /sys/fs/ext4/sdXX/lifetime_write_kbytes show me 19940467
>>
>> So:
>> 229h = 9,54 days
>> 19940467 kbytes / 9,54 days = 2Gb/day
>>
>> I think that it is too much. I use it on my laptop only to see my
>> e-mails (Thunderbird) and use OpenOffice.org on my work environment.
>
> If you've only had the disk for a short while, then the initial writes
> to install your system is probably biasing your results.  So far you
> have approximately 19GB of disk writes.  I'm guessing that at least
> 3-4GB is from the initial installation of software on your system.
>
> Also, if you are turning off your laptop at night, treating 229 hours
> as 9.5 days isn't really fair.  If you installed the SSD a month ago,
> then treat that as 30 days, and we get:
>
>       16GB / 30 == 0.533 GB
>
> This is well under the rated 20GB/day upon which Intel guarantees a
> five year life --- and most people don't keep their laptop and/or hard
> drives that long anyway.

Wow! You are really right!
Thank you so much Theodore, Eric and Florian!
I'm very happy with this SSD! It's really faster!

Regards,
Renato S. Yamane
