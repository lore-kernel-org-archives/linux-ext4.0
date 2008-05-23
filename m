From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Reoccurring ext3 errors: attempt to access beyond end of	device,
 freeing blocks not in datazone
Date: Fri, 23 May 2008 16:41:03 +0200
Message-ID: <4836D77F.30304@tuxes.nl>
References: <4832941A.70806@tuxes.nl> <20080520123505.GP15035@mit.edu> <48334A82.6020508@tuxes.nl> <20080522181827.GA3516@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a-eskwadraat.nl ([131.211.39.72]:47817 "EHLO a-eskwadraat.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYEWOlP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 May 2008 10:41:15 -0400
In-Reply-To: <20080522181827.GA3516@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On May 21, 2008  00:02 +0200, Bas van Schaik wrote:
>   
>> Theodore Tso wrote:
>>     
>>> 15629775440 / 8 = 0x74736E4A   (or in ascii 'Inst')
>>> 13075964688 / 8 = 0x616C6C62   (or in ascii 'blla')
>>> 15354014352 / 8 = 0x72657552   (or in ascii 'Ruer')
>>>
>>> Converting these numbers to hex:
>>>
>>> 1953721929 = 0x74736E49  (or in ascii 'Jnst')
>>> 1634495585 = 0x616C6C61  (or in ascii 'alla'
>>>  543517044 = 0x20656974  (or in ascii 'tie ')
>>> 1919251793 = 0x72657551  (or in ascii 'Quer')
>>>
>>> Given that it's all ascii, it looks like the indirect block somehow
>>> was overwritten, or was substituted by text.
>>>       
>> Ah, such a lead was exactly what I was looking for, now I at least know
>> where those bogus numbers were coming from. Maybe a very dump question:
>> you seem to have reverse the ascii "translation", why? And shouldn't
>> "Jnst" be "Inst"? Note also that the "translations" seem to resemble
>> each other a little bit: "Jnst" = "Jnst", "alla" looks like "blla" and
>> "Ruer" looks like "Quer". Coincidence?
>>     
>
> Or it is possible you are getting single-bit errors somewhere along
> your IO path, and another single-bit error has resulted in this data
> being written to the wrong block to begin with...
>   
I don't think I understand your statement fully... Do you mean that some
bitflip caused the filesystem to initiate a write to the wrong blocks?

  -- Bas
