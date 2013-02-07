From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: Used block count in df
Date: Thu, 07 Feb 2013 10:49:49 -0600
Message-ID: <5113DB2D.4000305@redhat.com>
References: <CANBXnM=H0ghqzQ5aJ_O+1C_sMJ850LQ9TOHLncOYkCKVSnUrAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab3BGQtz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 11:49:55 -0500
In-Reply-To: <CANBXnM=H0ghqzQ5aJ_O+1C_sMJ850LQ9TOHLncOYkCKVSnUrAw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/7/13 12:39 AM, Adil Mujeeb wrote:
> Hi,
> 
> I have an observation on EXT4 filesystem. I created filesystem of size
> 1TB, 4TB, and 7TB and then checked the output of df command.

Telling us which version of e2fsprogs and which kernel would be helpful,
but:

> df command showed the number of 1KB blocks used. The result was:
> 1TB: 204056
> 4TB: 198680
> 7TB: 181784

extN makes df complicated in several ways.

It reserves blocks for the superuser (5% by default) and also uses a lot
of blocks up-front for filesytem metadata - inode tables, block bitmaps,
and the like.

But what you are seeing here is this:

It also defaults to "bsd df" which does not count filesystem
metadata when telling you about the number of blocks used.  So in theory,
a freshly made fs should actually tell you 0 blocks used, I think.

Looking at the dumpe2fs output for the 4t file, I see:

# dumpe2fs -h 4tfile-ext4 | grep -i block
dumpe2fs 1.41.12 (17-May-2010)
Block count:              1073741824
Reserved block count:     53687091
Free blocks:              1056843748
...

and 1073741824-1056843748 is 16898076 4k blocks, or 67592304 1k blocks
actually used.

If we ask for "minix df" by mounting with -o minixdf which is true blocks used, we get:

# df 4t-ext4/
Filesystem           1K-blocks      Used Available Use% Mounted on
/mnt/test2/mkfs-test/4tfile-ext4
                     4294967296  67592304 4012626628   2% /mnt/test2/mkfs-test/4t-ext4

I'd say this appears to be a slight inaccuracy in ext4_statfs, coupled with
the strangeness of the "bsd df" reporting.  It is apparently miscalculating
the filesystem metadata "overhead."

> I performed the same on XFS and the result was:
> 1TB: 32928
> 4TB: 32928
> 7TB: 33024

XFS is straightforward; blocks used for metadata count as "used."
Every other block is free and available.
No fiddling around, just like with the minixdf mount option for extN.

-Eric

> EXT4 result shows with increasing filesystem size, the number of used
> blocks decreased. I dont have idea about low level implementation but
> I am curious why it is so?
> 
> Thanks.
> 
> Regards,
> Adil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

