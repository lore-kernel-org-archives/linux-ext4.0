From: Grzegorz Sikorski <g.sikorski@kelvatek.com>
Subject: Re: Question about data integrity on SD cards
Date: Wed, 09 Jul 2014 14:23:29 +0100
Message-ID: <53BD4251.3070501@kelvatek.com>
References: <53BD32D5.3000804@kelvatek.com> <alpine.LFD.2.00.1407091444140.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from outbound-jr2.exchangedefender.com ([65.99.255.229]:36868 "EHLO
	outbound-jr2.exchangedefender.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299AbaGINX1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2014 09:23:27 -0400
In-Reply-To: <alpine.LFD.2.00.1407091444140.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are using 2.6.37 version and we may have some issues with underlying=
=20
mmc-host driver. We also tested our setup on newer kernels as well as=20
different media with similar results, but I was not involved in these=20
tests, so cannot give any details straight away.

But my main question was partially answered by you. I just need a=20
confirmation that design of our system should in general be OK, as we=20
may expect random power downs occasionally. So do you think it is=20
possible (in general) to build embedded system with SQLite3 database on=
=20
EXT4 filesystem on SD card that is not fragile on unexpected power=20
sequence? Do you know what type of SD card would be recommended in this=
=20
case? Are our mounting options fine?

Thanks,
Greg

On 09/07/14 13:51, Luk=E1=9A Czerner wrote:
> On Wed, 9 Jul 2014, Grzegorz Sikorski wrote:
>
>> Date: Wed, 09 Jul 2014 13:17:25 +0100
>> From: Grzegorz Sikorski <g.sikorski@kelvatek.com>
>> To: linux-ext4@vger.kernel.org
>> Subject: Question about data integrity on SD cards
>>
>> Hi,
>>
>> In our project we use SQLite3 database on EXT4 filesystem partition =
on microSD
>> card. On unexpected power failure/system crash or just hardware rese=
t, we
>> observe occasional database corruption. SQLite3 developers claim the=
ir part is
>> free of risk of database corruption, as long as fsync call is doing =
it's job
>> properly. We tried several SD cards, including industrial grade whic=
h should
>> have proper firmware (at least their manufacturers say there is no r=
isk of
>> data corruption on power loss). We tried several different mount set=
tings and
>> after some reading we found, that the safest (and slowest) option (t=
hat should
>> never fail, as far as we understand) would be like:
>> rw,relatime,barrier=3D1,journal_checksum,nodelalloc,data=3Djournal,u=
srquota
>> In spite of all that, we still observe random database corruption on
>> power-down/reset. Can you confirm there is no problem in EXT4 filesy=
stem?
> There have been reports on SD cards not working correctly on power
> failure, most likely due to flush not working correctly. It was
> mentioned several times in this huge thread (concerning different
> problem, but maybe related)
> http://www.spinics.net/lists/linux-ext4/msg43974.html
>
> At this point we do not know about any problems with ext4 file
> system regarding fsync functionality. However you have not said
> which kernel you are using.
>
> Also, have you tried reproducing it on a different hardware, let's
> say SSD, or spinning disk ? Do you have any SD card which seems to
> be working reliably across power failures, or did you see that
> behaviour with all SD cards you've tested ?
>
> Thanks!
> -Lukas
>
>> Best regards,
>> Greg
>>
>> --
>> ExchangeDefender Message Security: Click below to verify authenticit=
y
>> https://admin.exchangedefender.com/verify.php?id=3Ds69CHHv3024052&fr=
om=3Dg.sikorski@camlintechnologies.com
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


--
ExchangeDefender Message Security: Click below to verify authenticity
https://admin.exchangedefender.com/verify.php?id=3Ds69DNLGC013653&from=3D=
g.sikorski@camlintechnologies.com


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
