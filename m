From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem size problem.
Date: Fri, 9 Dec 2016 22:35:07 -0600
Message-ID: <46f8665e-c3b5-b2e9-346b-4bbb380bb6e2@redhat.com>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
 <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
 <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>,
        Simon Matthews <simon.d.matthews@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751623AbcLJEfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Dec 2016 23:35:08 -0500
In-Reply-To: <6B4536F9-A059-45AC-8A14-85879FC4AC79@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/9/16 2:29 PM, Andreas Dilger wrote:
> On Dec 8, 2016, at 10:40 PM, Simon Matthews <simon.d.matthews@gmail.com> wrote:
>>
>> I have an ext3 filesystem that will not mount under newer versions of
>> the kernel and I hope someone here can help.
>>
>> Obviously, one solution is "backup and re-create from scratch". I have
>> the backups, but I hope that there may be a quicker method to fix the
>> issues.
>>
>> The root issue is that the filesystem is very slightly smaller than
>> the allocated space.

So the device is now smaller than the filesystem thinks, right?

> The filesystem exists on a MDRAID device and I
>> think that when I converted the MDRAID to a newer metadata version, it
>> truncated the available size, slightly. However, how I got here isn't
>> really important, fixing it now is.
> 
> Running "e2fsck -fy" should fix this.  I'd recommend to use the latest
> version of e2fsck.

Reaslly?  e2fsck can change total blocks in the superblock to accomodate a
shrunken device?  That's a new one for me...

I don't think so:

$ truncate --size=101m testfile
$ mkfs.ext3 testfile
$ truncate --size=100m testfile
$ e2fsck -f testfile
...
The physical size of the device is 102400 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? n
...
$ e2fsck -f testfile
...
The physical size of the device is 102400 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? n
$ e2fsck -f testfile
...
The physical size of the device is 102400 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort<y>? n

etc.


The proper solution is to fix your block device, not the filesystem; it was
the block device which was inappropriately shortened.

I don't know if just poking a smaller total blocks number into the superblock
via debugfs would be safe or not.

-Eric

> Cheers, Andreas

