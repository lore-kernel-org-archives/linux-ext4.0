From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Is EXT4 the right FS for > 16TB?
Date: Sun, 19 Dec 2010 11:53:09 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1012191151570.28865@p34.internal.lan>
References: <alpine.DEB.2.00.1012190649060.5393@p34.internal.lan> <4D0E3435.30104@van-ness.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>,
	Eric Sandeen <sandeen@sandeen.net>
To: Sandon Van Ness <sandon@van-ness.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:37182 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0LSQxK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Dec 2010 11:53:10 -0500
In-Reply-To: <4D0E3435.30104@van-ness.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Wow, there were no updates though after Eric's last comment..
Eric, have there been any improvements in the past 6 months?

Or should one still steer clear from EXT4 > 16TB?

Justin.

On Sun, 19 Dec 2010, Sandon Van Ness wrote:

> Was it me (houkouonchi) on hard forum? I asked if > 16 TiB support was
> considered stable on here a while back:
>
> Is >16TB support considered stable?
>
> This was 6 months ago so maybe things have changed. The thread:
>
> http://kerneltrap.org/mailarchive/linux-ext4/2010/5/28/6884603/thread
>
> Luckily JFS fixed there userland utilities bug of not being able to
> handle > 32TiB very shortly after this and I ended up going that route
> and I have yet to have any data loss or problems on my JFS volume:
>
> root@dekabutsu: 08:32 AM :~# df -H /data
> Filesystem             Size   Used  Avail Use% Mounted on
> /dev/sdd1               36T    22T    15T  61% /data
> root@dekabutsu: 08:32 AM :~#
>
> At work with our hundreds/thousands of servers we will likely be going
> ext4 as we wont be using it on >16 TiB. I think its a huge improvement
> over ext3 but for my use JFS ended up being a better fit. I
> refuse/refused to go XFS.
>
> On 12/19/2010 03:52 AM, Justin Piszcz wrote:
>> Hi,
>>
>> I've read a lot of posts regarding people who setup RAID volumes of
>> and up to around 16TB and EXT4 is typically used.
>>
>> However, in various forums, people still ask what is the correct
>> filesystem for > 16TB?  I did read one post somewhere that stated the
>> ext4 developers did not recommend using ext4 for very large volumes,
>> is this still true?
>>
>> I am looking at creating a 43TB volume possibly in the near future and
>> I have used XFS in the past, which works well and would probably not
>> have any problem with it; however, I have bitten quite a number of
>> times by XFS bugs in the past several years, so I was curious, how
>> does EXT4 perform on larger volumes, e.g., 20TB?
>>
>> Are there any caveats / problems?
>>
>> Justin.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
