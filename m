From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 13:37:42 -0400
Message-ID: <x49ty01i0ih.fsf@segfault.boston.devel.redhat.com>
References: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
	<4F9ECC0E.8020201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Drake <dsd@laptop.org>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab2D3Rhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 13:37:55 -0400
In-Reply-To: <4F9ECC0E.8020201@redhat.com> (Eric Sandeen's message of "Mon, 30
	Apr 2012 12:29:50 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> On 4/30/12 12:19 PM, Daniel Drake wrote:
>> Hi,
>> 
>> OLPC has started using ext4 online resizing to grow our filesystems to
>> use the whole SD card on first boot - something we never did before.
>> Working very nicely, thanks!
>> 
>> I'm trying to simplify/improve the scripts involved in doing this.
>> 
>> How can I programatically check if an ext4 fs already fills its
>> partition, or if it has room to grow?
>> 
>> 
>> The numbers produced by dumpe2fs (e.g. block count) or "df" don't seem
>> to exactly line up with the sizes produced by fdisk.
>
> Do you have an example of this?
>
> For starters, use fdisk -u to get 512-byte sector units,
> otherwise it's just inscrutable CHS magic.

Note that fdisk -u gives sector units, which may or may not be 512
bytes:

$ sudo fdisk -lu /dev/sdb
Note: sector size is 4096 (not 512)

Disk /dev/sdb: 300.1 GB, 300069052416 bytes
255 heads, 63 sectors/track, 4560 cylinders, total 73259046 sectors
Units = sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

Cheers,
Jeff
