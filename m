From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH 14/17] super->s_*_blocks_count -> ext2fs_*_blocks_count()
Date: Fri, 14 Nov 2008 10:24:10 -0600
Message-ID: <491DA62A.5020908@redhat.com>
References: <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <1226461390-5502-12-git-send-email-vaurora@redhat.com> <1226461390-5502-13-git-send-email-vaurora@redhat.com> <1226461390-5502-14-git-send-email-vaurora@redhat.com> <1226461390-5502-15-git-send-email-vaurora@redhat.com> <20081113202441.GY16005@webber.adilger.int> <20081114032531.GI20637@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39860 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNQYg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Nov 2008 11:24:36 -0500
In-Reply-To: <20081114032531.GI20637@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora Henson wrote:
> On Thu, Nov 13, 2008 at 01:24:41PM -0700, Andreas Dilger wrote:
>> Since it isn't yet common to be able to test > 32-bit blocks
>> these bugs may go unnoticed for some time.  It would be nice to be able
>> to test 64-bit support easily with e2fsprogs.  Maybe truncate file
>> to > 16TB in size (abort if underlying filesystem isn't able to do this),
>> use "lazy_bg" or equivalent to avoid writing many GB of data into the
>> sparse file, then run e2fsck on it after putting some files at the end.
>> This could probably be done by the "script" support in "make check".
> 
> Unfortunately, ext4 doesn't support a file this big so you'd have to
> deliberately put your e2fsprogs tree on XFS or something like that for
> this automatic check to actually help - not a terribly common
> situation for an e2fsprogs developer. (I'm doing all my testing on
> sparse files on XFS, which definitely chafes - nothing wrong with XFS,
> just kind of annoying that I can't self-host e2fsprogs development.)
> 
> Hummm... Would it work to use LVM to glue together two loopback
> devices backed by files that sum to just over 16TB?

Or you could play with devicemapper, see
Documentation/device-mapper/zero.txt:

One very interesting use of dm-zero is for creating "sparse" devices in
conjunction with dm-snapshot. A sparse device reports a device-size
larger than the amount of actual storage space available for that
device. A user can write data anywhere within the sparse device and read
it back like a normal device. Reads to previously unwritten areas will
return a zero'd buffer. When enough data has been written to fill up the
actual storage space, the sparse device is deactivated. This can be very
useful for testing device and filesystem limitations.

To create a sparse device, start by creating a dm-zero device that's the
desired size of the sparse device. For this example, we'll assume a 10TB
sparse device.

TEN_TERABYTES=`expr 10 \* 1024 \* 1024 \* 1024 \* 2`  # 10 TB in sectors
echo "0 $TEN_TERABYTES zero" | dmsetup create zero1

Then create a snapshot of the zero device, using any available
block-device as the COW device. The size of the COW device will
determine the amount of real space available to the sparse device. For
this example, we'll assume /dev/sdb1 is an available 10GB partition.

echo "0 $TEN_TERABYTES snapshot /dev/mapper/zero1 /dev/sdb1 p 128" | \
   dmsetup create sparse1

This will create a 10TB sparse device called /dev/mapper/sparse1 that
has 10GB of actual storage space available. If more than 10GB of data is
written to this device, it will start returning I/O errors.

-Eric

