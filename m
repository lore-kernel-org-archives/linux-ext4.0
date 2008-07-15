From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 23:03:31 +0200
Message-ID: <87mykirhb0.fsf@frosties.localdomain>
References: <87bq10w8gv.fsf@frosties.localdomain>
	<20080715132734.68c64000@ichigo>
	<20080715195116.GL6239@webber.adilger.int> <487D0572.50503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	"Jose R. Santos" <jrs@us.ibm.com>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:54821 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYGOVDf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 17:03:35 -0400
In-Reply-To: <487D0572.50503@gmail.com> (Ric Wheeler's message of "Tue, 15 Jul
	2008 16:15:46 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler <ricwheeler@gmail.com> writes:

> Andreas Dilger wrote:
>> Jose,
>> while waiting for the "efficient bitmap" support, how hard would it be
>> to implement "inefficient bitmaps" that just malloc some GB of memory
>> if needed?  This would at least allow people with huge devices to test
>> mke2fs/ext4/e2fsck in the meantime.
>>
>> Cheers, Andreas
>> --
>> Andreas Dilger
>> Sr. Staff Engineer, Lustre Group
>> Sun Microsystems of Canada, Inc.
>>
>>
>
> I think that would be very useful - how much DRAM would we need for a
> 16TB file system ;-) ?
>
> ric

The patched 1.39 e2fsprogs managed to format a 16TIB under kvm with
1GiB ram and 128k swap. A 32TiB disk format uses nearly 1GiB ram for mkfs
alone and eventualy managed to deadlock the I/O layer in kvm with
1.5GB ram and 128k swap. (Something I'm sure is kvms fault. :)

But fsck is suposed to eat more by a factor (see other mails in
thread). So having 4-16GiB ram is probably recommended for anyone
thinking about testing.


I used the sparse_create script linked on one of the ext4 wiki pages
with a sparse loopback file and used mke2fs -i $((64*1024*1024)) to
speed up things. With that a 16TiB ext4 uses somewhat over 4GiB
freshly formated.

MfG
        Goswin
