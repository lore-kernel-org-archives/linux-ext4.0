From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: use lazy inode init on some discard-able devices
Date: Mon, 23 Aug 2010 18:27:26 -0600
Message-ID: <352B89DD-8FEC-4BB8-8D77-13DC2F5B5B17@dilger.ca>
References: <4C6EF67A.5080502@redhat.com> <D416033E-58F9-46F8-B8B0-546C949CB6BE@mit.edu> <4C728688.6080007@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:36271 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0HXA12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Aug 2010 20:27:28 -0400
In-Reply-To: <4C728688.6080007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-23, at 08:32, Eric Sandeen wrote:
> Theodore Tso wrote:
>> On Aug 20, 2010, at 5:41 PM, Eric Sandeen wrote:
>> 
>>> If a device supports discard -and- returns 0s for discarded blocks,
>>> then we can skip the inode table initialization -and- the inode table
>>> zeroing at mkfs time, and skip the lazy init as well since they are
>>> already zeroed out.
>>> 
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> 
>> This needs to be configurable in /etc/mke2fs.conf.  Without naming 
>> the manufacturer, I'm aware of at least one device which claims that
>> discard works, and will even return zeros --- but after a power
>> cycle, if the block has not been reallocated, will once again return
>> the old, pre-discard values that had been stored in that block.
>> 
>> In other words, the discard is not power-cycle persistent...
> 
> yes, I've seen issues like that too.
> 
> TBH in that case I'd rather just drop the patch than make another
> tunable for the user to figure out...

What else we discussed is to have mke2fs validate whether the discard+zero works (i.e. write some small non-zero data, discard the whole device, read back previously written data).  Granted it wouldn't handle this "it only fails after a power-cycle" problem, but it should detect gratuitously broken hardware.

That should be sufficiently safe until such a time that inode checksums are available.  Note also that non-zero inode table blocks are only a major problem if some additional corruption causes the itable_uninit numbers to become invalid (e.g. bad group checksum) at which case the old itable blocks will be used.

We also discussed doing this at least for sparse files, which makes a lot of sense for testing in any case, even if the default is not to do this for SSD devices until they smarten up.


Cheers, Andreas





