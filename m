From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Reoccurring ext3 errors: attempt to access beyond end of	device,
 freeing blocks not in datazone
Date: Thu, 22 May 2008 00:27:02 +0200
Message-ID: <4834A1B6.7090803@tuxes.nl>
References: <4832941A.70806@tuxes.nl> <20080520123505.GP15035@mit.edu> <48334A82.6020508@tuxes.nl> <20080521113855.GD8581@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pollux.sshunet.nl ([145.97.192.42]:38876 "EHLO
	pollux.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761485AbYEUW1L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 May 2008 18:27:11 -0400
In-Reply-To: <20080521113855.GD8581@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, May 21, 2008 at 12:02:42AM +0200, Bas van Schaik wrote:
>   
>> Ah, such a lead was exactly what I was looking for, now I at least know
>> where those bogus numbers were coming from. Maybe a very dump question:
>> you seem to have reverse the ascii "translation", why? 
>>     
>
> x86 (and the ext3 indirect blocks) are stored in little endian format.
> If you doubt me, try running this program:
>
> main(int argc, char **argv)
> {
> 	char	a[5];
> 	int	*b;
>
> 	b = (int *) a;
> 	*b = 0x61626364;
> 	a[4] = 0;
> 	printf("%s\n", a);
> }
>   
No, I certainly do most certainly not doubt you. I was just wondering...

>> Summarizing all this: there is clearly something writing garbage to the
>> wrong place. It must be something above the encryption layer, since
>> that's the only way ascii can be written to the device.
>>
>> Remember the different layers:
>>   ext3 on decrypted /dev/loop0
>>   LVM logical volume (encrypted)
>>   RAID5 arrays
>>   Imported AoE-devices
>>   Physical disks
>>
>> This conclusion kind of worries me, I was assuming that there was
>> something wrong at the networking level (AoE) or below. If that were the
>> case, the encrypted data would get modified and the corruptions would
>> look totally different. Or am I missing something?
>>     
>
> Not necessarily, this could be simply valid data getting written to
> the wrong place. 
>   
Of course, but there are no processes performing direct I/O to one of
the underlying block devices. So how could plain ascii data get written
to the wrong place and still appear as plain ascii after decrypting it?

> How are you encrypting your loop device, and what encryption system
> are you using?
>   
I think this tells you everything:
> cat $KEYFILE | losetup -e aes128 -p0 /dev/loop0 /dev/vg_backups2/backups

However, the other system I was mentioning is using LUKS (dm-crypt) to
achieve the same goal.

> What sort of workload are you using with your filesystem, what version
> of the kernel are your running, and does the machine crash often
> (i.e., forcing journal replays)?
The system is under high load: sometimes there are about 20 rsync server
processes fighting for some time. As you might know, rsync is not really
thrifty with claiming resoures, especially not when building file lists.
The machine itself doesn't crash, it seems to be perfectly stable. These
corruptions are the only problem...

  -- Bas
