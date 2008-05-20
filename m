From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Reoccurring ext3 errors: attempt to access beyond end of	device,
 freeing blocks not in datazone
Date: Wed, 21 May 2008 00:02:42 +0200
Message-ID: <48334A82.6020508@tuxes.nl>
References: <4832941A.70806@tuxes.nl> <20080520123505.GP15035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from castor.sshunet.nl ([145.97.192.41]:60535 "EHLO
	castor.sshunet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768AbYETWCr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2008 18:02:47 -0400
In-Reply-To: <20080520123505.GP15035@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
>> After running e2fsck everything is fine again for a week or a little
>> longer...
>>     
>
> Did e2fsck report any errors?  You didn't say; but if this kind of
> corruption were really on the hard drive itself, it would cause e2fsck
> to scream bloody murder. 
>   
Yeah, I'm sorry: e2fsck did scream bloody murder. After the check, the
filesystem is clean again and remains clean for about a week. I still
haven't found out what operation exactly is causing the problems, the
only thing I can think of is rsync eating too much memory. The system is
used for backups of about 50 rsync clients, but the system should be
able to handle this even under high load.

>>> May 20 09:13:14 infinity kernel: attempt to access beyond end of device
>>> May 20 09:13:14 infinity kernel: loop0: rw=0, want=15629775440, limit=4404019200
>>>       
> So for these, you had
>
> 15629775440 / 8 = 0x74736E4A   (or in ascii 'Jnst')
> 13075964688 / 8 = 0x616C6C62   (or in ascii 'blla')
> 15354014352 / 8 = 0x72657552   (or in ascii 'Ruer')
>
> These errors errors happen when deleting a file with a bogus indirect
> block (or garbage in the inode, but that's much less likely and
> probably would have triggered additional complaints).
>
>   
>>> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1953721929, count = 1
>>>       
> Converting these numbers to hex:
>
> 1953721929 = 0x74736E49  (or in ascii 'Jnst')
> 1634495585 = 0x616C6C61  (or in ascii 'alla'
>  543517044 = 0x20656974  (or in ascii 'tie ')
> 1919251793 = 0x72657551  (or in ascii 'Quer')
>
> Given that it's all ascii, it looks like the indirect block somehow
> was overwritten, or was substituted by text.
>   
Ah, such a lead was exactly what I was looking for, now I at least know
where those bogus numbers were coming from. Maybe a very dump question:
you seem to have reverse the ascii "translation", why? And shouldn't
"Jnst" be "Inst"? Note also that the "translations" seem to resemble
each other a little bit: "Jnst" = "Jnst", "alla" looks like "blla" and
"Ruer" looks like "Quer". Coincidence?

Summarizing all this: there is clearly something writing garbage to the
wrong place. It must be something above the encryption layer, since
that's the only way ascii can be written to the device.

Remember the different layers:
  ext3 on decrypted /dev/loop0
  LVM logical volume (encrypted)
  RAID5 arrays
  Imported AoE-devices
  Physical disks

This conclusion kind of worries me, I was assuming that there was
something wrong at the networking level (AoE) or below. If that were the
case, the encrypted data would get modified and the corruptions would
look totally different. Or am I missing something?

Some other "magic numbers" to test the ascii hypothesis:
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1279611658, count = 1
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 779051620, count = 1
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1701409346, count = 1
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1634366310, count = 1
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1869573218, count = 1
> May 20 09:15:07 infinity kernel: EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in datazone - block = 1783836270, count = 1
1279611658 = 0x4C45530A = "SEL"
779051620 = 0x2E6F6264 = "dbo."
1701409346 = 0x65697242 = "Brie"
1634366310 = 0x616A7366 = "fsja"
1869573218 = 0x6F6F6C62 = "bloo"
1783836270 = 0x6A532E6E = "n.Sj"

If you ask me: enough certainty that it is indeed ascii text that was
written to the wrong place. Point is that I have another storage
"cluster" with almost exactly the same setup (main difference: LUKS is
used in favour of some AES cryptoloop). This cluster appears to be
having exactly the same problems:

> May 20 01:09:09 dust kernel: EXT3-fs error (device dm-10): ext3_free_blocks: Freeing blocks not in datazone - block = 4292870144, count = 1
> May 20 01:09:09 dust kernel: EXT3-fs error (device dm-10): ext3_free_blocks: Freeing blocks not in datazone - block = 3137339670, count = 1
> May 20 01:09:09 dust kernel: EXT3-fs error (device dm-10): ext3_free_blocks: Freeing blocks not in datazone - block = 892220416, count = 1
> May 20 01:09:09 dust kernel: EXT3-fs error (device dm-10): ext3_free_blocks: Freeing blocks not in datazone - block = 1919240224, count = 1
> May 20 01:09:09 dust kernel: EXT3-fs error (device dm-10): ext3_free_blocks: Freeing blocks not in datazone - block = 1768710504, count = 1
> May 20 01:09:09 dust kernel: EXT3-fs error (device dm-10): ext3_free_blocks: Freeing blocks not in datazone - block = 1920165742, count = 1
Convert these numbers to hex and ascii and you'll see that the outcome
doesn't look like "plain" ascii. This can mean two things (correct me if
I'm wrong):
 1) there is a totally different problem
 2) the data which was written to the wrong place wasn't plain ascii

I would really like to hear your thoughts on all this, maybe there is a
simple explanation out there after all...

  -- Bas
**
