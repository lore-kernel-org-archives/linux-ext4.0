From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Tue, 29 Jun 2010 17:12:10 +0200
Message-ID: <4C2A0D4A.6040808@gmail.com>
References: <4C278EC2.1080903@gmail.com> <20100629135644.GE6094@thunk.org> <4C2A04C2.7040300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:55511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab0F2PMQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jun 2010 11:12:16 -0400
Received: by fg-out-1718.google.com with SMTP id e21so859653fga.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jun 2010 08:12:13 -0700 (PDT)
In-Reply-To: <4C2A04C2.7040300@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

just to give an example of reading "host writes" from SSD S.M.A.R.T
attribute:

###################################

tnt ~ # smartctl -A /dev/sda|grep 225
225 Load_Cycle_Count        0x0030   200   200   000    Old_age
Offline      -       6939
tnt ~ # dd if=/dev/zero of=somefile.tmp bs=1M count=128
128+0 records in
128+0 records out
134217728 bytes (134 MB) copied, 0.0708615 s, 1.9 GB/s
tnt ~ # smartctl -A /dev/sda|grep 225
225 Load_Cycle_Count        0x0030   200   200   000    Old_age
Offline      -       6939
tnt ~ # sync
tnt ~ # smartctl -A /dev/sda|grep 225
225 Load_Cycle_Count        0x0030   200   200   000    Old_age
Offline      -       6943
tnt ~ #

###################################




On 06/29/10 16:35, Nebojsa Trpkovic wrote:
>> On 06/29/10 15:56, tytso@mit.edu wrote:
>> On Sun, Jun 27, 2010 at 07:47:46PM +0200, Nebojsa Trpkovic wrote:
>>> My best guess is that host itself uses a lot of optimisation to reduce
>>> writing to NAND itself.
>>
>> Possible, although if the counter is defined as "host writes", that
>> should be before the NAND writes, since "host writes" would expect
>> means the actual write commands coming from the host -- i.e., coming
>> incoming SATA write commands.
> 
> That's true. Maybe Intel gave wrong name to that variable, as they are
> trying to keep track of NAND wear, not SATA write commands. Then again,
> maybe it's just amount of SATA writes.
> 
>>> Besides that, I've noticed that my commit=100 mount option helps also.
>>> Changing (just for testing) to something realy big, like commit=9000,
>>> gave even further improvement, but not worth staying with risk of losing
>>> (that much) data. It seems that ext4 writes a lot to filesystem, but
>>> many of those writes are overwrites. If we flush them to host just once
>>> in 100 seconds, we're getting a lot of saving.
>>
>> What metric are you using when you say that this "helps"?  The ext4
>> measurement, the SSD counter which you are using, or both?
> 
> I've made graph with rrdtool to track both lifetime_write_kbytes and
> host writes from SSD. It looks like this:
> http://img130.imageshack.us/img130/6905/systemg29year.png
> with lifetime_writes_kbytes decreasing on unclean shutdown.
> "host writes" counter read from SSD starts at bigger value because I've
> done some testing with SSD before I've made sda1 and formated it.
> Since then, trend is quite obvious. Differences in line slopes are due
> different type of usage from time to time.
> 
>>> As I wanted to make even my swap TRIMable, I've put it in the file on
>>> ext4 instead of separate partition. I've made it using dd with seek=500
>>> bs=1M options. ext4's lifetime_write_kbytes increased by 500MB, and host
>>> writes did not incrase at all, even after 100 seconds. Ok, I know that
>>> ext4 did not write 500MB of data to filesystem, but this is one more
>>> thing why one should not trust lifetime_write_kbytes.
>>
>>> So, the moral of my story would be not to trust lifetime_write_kbytes,
>>> but to read host writes from SSD.
>>
>> If you wrote 500MB to a swap file in ext4 using dd, why are you sure
>> ext4 didn't write 500MB of data to the disk?  In fact, this would
>> imply to me that that your "host writes" shouldn't be trusted.
> 
> I've used dd with bs=1M, seek=500 and count=1 option, making file of
> 500MB but writting just last megabyte of it to avoid unnecessary SSD
> writes during swap-file cration.
> 
>>> I noticed that Intel's Solid State Drive Toolbox software (running in
>>> Windows) gives the amount of Host Lifetime Writes that equales to
>>> S.M.A.R.T attribute 225 (Load_Cycle_Count) multiplied with 32MB.
>>> That's the way I track it in Linux.
>>
>> According to the S.M.A.R.T startd, Load_cycle_count is supposed to
>> mean the number of times the platter has spun up and spin down.  It's
>> not clear what it means for SDD's, so it may be that they have reused
>> it for some other purpose.  However, it would be surprising to me that
>> it was just host lifetime writes divided by 32MB.  It may be that you
>> have noticed this correlation in Windows because Windows is very
>> "chunky" in how it does its writes.
> 
> I've found out about that S.M.A.R.T value by constant comparing of "host
> writes" that I see in Intel's SSD Toolbox and my calculated graph of
> "host writes" (32MB * SMART value 225).
> Everytime I reboot my box and boot Windows 7 residing on external HDD, I
> start Intel SSD Toolbox that gives me "host writes" amount using nice
> looking GUI. Whenever I rebooted in Windows, I've seen those values to
> match. I guess that Intel just missuses S.M.A.R.T. value not needed for
> theier SSD violating S.M.A.R.T. standard, but at least, I can get that
> info in Linux without Intel SSD toolbox.
> 
>> However, if you write 500MB to a file in ext4 using dd, and ext4's
>> lifetime_write_kbytes in /sysfs went up by 500MB, but the
>> Load_Cycle_Count attribute did not go up, then I would deduce from
>> that that your interpretation of Load_Cycle_Count is probably not
>> correct...
> 
> I've explained this before. Maybe I'm wrong, but in my opinion
> 
> dd if=/dev/zero of=somefile bs=1M seek=500 count=1
> 
> should make 500MB file with just 1MB writen to disk. Even df should not
> register absence of 500MB of free space.
> 
> Nebojsa
