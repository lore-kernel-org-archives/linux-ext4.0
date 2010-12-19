From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Is EXT4 the right FS for > 16TB?
Date: Sun, 19 Dec 2010 11:01:23 -0600
Message-ID: <4D0E3A63.606@sandeen.net>
References: <alpine.DEB.2.00.1012190649060.5393@p34.internal.lan> <4D0E3435.30104@van-ness.com> <alpine.DEB.2.00.1012191151570.28865@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Sandon Van Ness <sandon@van-ness.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-28-21.usfamily.net ([64.131.28.21]:47272 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab0LSRB1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Dec 2010 12:01:27 -0500
In-Reply-To: <alpine.DEB.2.00.1012191151570.28865@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/19/10 10:53 AM, Justin Piszcz wrote:
> Hi,
> 
> Wow, there were no updates though after Eric's last comment..
> Eric, have there been any improvements in the past 6 months?
> 
> Or should one still steer clear from EXT4 > 16TB?

There is still no released e2fsprogs which supports > 16T for
ext4, but testing of the not-released bits is welcomed...
Ted says a 16T-capable version is coming soon.  There's still
work to be done there, though.

-Eric

> Justin.
> 
> On Sun, 19 Dec 2010, Sandon Van Ness wrote:
> 
>> Was it me (houkouonchi) on hard forum? I asked if > 16 TiB support was
>> considered stable on here a while back:
>>
>> Is >16TB support considered stable?
>>
>> This was 6 months ago so maybe things have changed. The thread:
>>
>> http://kerneltrap.org/mailarchive/linux-ext4/2010/5/28/6884603/thread
>>
>> Luckily JFS fixed there userland utilities bug of not being able to
>> handle > 32TiB very shortly after this and I ended up going that route
>> and I have yet to have any data loss or problems on my JFS volume:
>>
>> root@dekabutsu: 08:32 AM :~# df -H /data
>> Filesystem             Size   Used  Avail Use% Mounted on
>> /dev/sdd1               36T    22T    15T  61% /data
>> root@dekabutsu: 08:32 AM :~#
>>
>> At work with our hundreds/thousands of servers we will likely be going
>> ext4 as we wont be using it on >16 TiB. I think its a huge improvement
>> over ext3 but for my use JFS ended up being a better fit. I
>> refuse/refused to go XFS.
>>
>> On 12/19/2010 03:52 AM, Justin Piszcz wrote:
>>> Hi,
>>>
>>> I've read a lot of posts regarding people who setup RAID volumes of
>>> and up to around 16TB and EXT4 is typically used.
>>>
>>> However, in various forums, people still ask what is the correct
>>> filesystem for > 16TB?  I did read one post somewhere that stated the
>>> ext4 developers did not recommend using ext4 for very large volumes,
>>> is this still true?
>>>
>>> I am looking at creating a 43TB volume possibly in the near future and
>>> I have used XFS in the past, which works well and would probably not
>>> have any problem with it; however, I have bitten quite a number of
>>> times by XFS bugs in the past several years, so I was curious, how
>>> does EXT4 perform on larger volumes, e.g., 20TB?
>>>
>>> Are there any caveats / problems?
>>>
>>> Justin.
