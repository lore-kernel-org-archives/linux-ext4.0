From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 > 16T woes
Date: Wed, 23 May 2012 14:48:51 -0500
Message-ID: <4FBD3F23.50504@redhat.com>
References: <4FBD3102.6050001@redhat.com> <E47B57D8-FA33-42D7-8C3D-2785B3643C0D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760680Ab2EWTsy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 May 2012 15:48:54 -0400
In-Reply-To: <E47B57D8-FA33-42D7-8C3D-2785B3643C0D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/23/12 2:33 PM, Andreas Dilger wrote:
> On 2012-05-23, at 12:48 PM, Eric Sandeen wrote:
>> I'll try to look into this but just wanted to put it out there.
>>
>> After creating a 32T fs and filling it with 1T preallocated files,
>> I get quite a lot of corruption; this wasn't really the test
>> I wanted to do, I wanted to then remove a file with mostly
>> high blocks, run fsstress, and test recovery :(
> 
> Hmm, we've done full-filesystem write + read +verify + e2fsck up to
> 128TB (took several days to write and read so much data) with RHEL6
> without similar problems (up to 32TB on RHEL5) using real disks.
> 
> We don't use fallocate() or loop devices, so it may be that some
> problems are therein, or possibly with newer kernels.
> 
> Presumably this is using XFS for the backing loop file?  I don't
> anticipate problems with that, but there may be strange interactions
> between fallocate(), sparse files, and TRIM/DISCARD?

It is backed by XFS, yes.  I don't think I'm freeing any blocks during
the test, so I wouldn't expect discard to come into it.  Really, all it
should be doing is writing fairly small amounts of metadata, right?

I'll keep investigating.

-Eric

>> # uname -r
>> 3.4.0-rc4+
>> # truncate --size 32t imagefile2
>> # mkfs.ext4 -F imagefile2
>> mke2fs 1.42.3 (14-May-2012)
>> ...
>> # mount -o loop imagefile2 /mnt/scratch
>> # for I in `seq 1 32`; do fallocate -l 1t /mnt/scratch/1tfile$I; done
>> # umount /mnt/scratch
> 
> Did you try sync here, or running e2fsck on the loop device instead
> of the backing file?  It looks like nothing was written to disk...
> 
>> # time e2fsck -fn imagefile2
>> e2fsck 1.42.3 (14-May-2012)
>> <many many many lines snipped>
>> Free blocks count wrong for group #131072 (0, counted=32768).
>> Fix? no
>>
>> Free blocks count wrong for group #131073 (0, counted=32768).
>> Fix? no
>>
>> Free blocks count wrong for group #131074 (0, counted=4164).
>> Fix? no
>>
>> Free blocks count wrong (3, counted=4294967299).
>> Fix? no
>>
>>
>> imagefile2: ********** WARNING: Filesystem still has errors **********
>>
>> imagefile2: 43/536870912 files (0.0% non-contiguous), 8589934589/8589934592 blocks
>>
>> real	27m40.133s
>> user	27m12.886s
>> sys	0m6.238s
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

