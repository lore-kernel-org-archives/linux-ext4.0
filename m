From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 16 TB filesystem limit on 32bit machine
Date: Mon, 20 Feb 2012 10:50:57 -0600
Message-ID: <4F4279F1.8060805@redhat.com>
References: <CAJZuRVZ5BC+oJA_4HqdwnJvME8XuDeCWWt_6pugOuBFjp8v_SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Rabeeh Khoury <rabeeh3000@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2BTQu5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 11:50:57 -0500
In-Reply-To: <CAJZuRVZ5BC+oJA_4HqdwnJvME8XuDeCWWt_6pugOuBFjp8v_SQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/20/12 9:31 AM, Rabeeh Khoury wrote:
> I'm trying to figure out all issues with regards >16TB filesystem
> support on ARM (32bit) machines.
> Clearly this issue was hot few years ago, part of the discussions -
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=12556
> http://www.redhat.com/archives/dm-devel/2009-July/msg00131.html
> 
> And there was Eric's patch of checking length of pgoff_t and
> accordingly refuse mount.
> 
> Now, today with 4TB hard drives in the market, having 5 of those on an
> ARM machine is really common and the ext4 limitation is becoming more
> reachable and requires attention.

It's not an ext4 limitation, though - it's a limitation of the pagecache.
With a 32-bit index into 4k pages, you can only address 16T in the
pagecache.  XFS won't mount it either, for example.

> What i'm trying to achieve is the following two items -
> 
> ---- item #1 ---
> Understand where the limitation is really coming from? Is this ext4
> implementation limitation or 32bit machines will never work with >16TB
> filesystems?

The latter, see above.

> I understand that there is a 16TB file size limitation (2^32*4K page
> size so you won't be able to mmap() further than that point) but how
> is that related to filesystem size?

fs metadata is mapped into an address space, IIRC, so can't be addressed
past 2^32 pages.  Also, mkfs can't do buffered IO to the device past
16T (it is writing to a device _file_) and ditto for e2fsck.

> Will 64KB page size fix this issue (ARM supports 4KB and 64KB pages) -
> clearly memory fragmentation will be a hit here.

If you can have 64k pages, I think you can address 2^32 * 64k.

> ----- item #2 ---
> Reproduce a failing scenario.
> For now i'v created a 24TB volume (thin provisioned) - RAID-0 on a 3 x
> loopback on a 3 x truncted 8TB consisting total of 24TB volume
> mkfs.ext4 /dev/md0 (e2fsprogrs 1.42 - thanks for the >16TB support)
> mount on a hacked kernel (#define pgoff_t unsigned long long thus
> making filesystem mounting check disappear)

that's the other way to do it; pgoff_t was made a typedef just
for that reason, but someone would need to audit a ton of code
to be sure it's used consistently, and doesn't overflow anywhere,
before it can be made larger.

Another thing to consider is whether you can successfully run e2fsck
on a very large filesystem on this box, even if you resolve the above
issues.  Would you have the resources you need to fsck, say, a 32T fs
if^Wwhen something goes wrong?

-Eric

> The volume mounts ok; now how do i get into corruption? I don't have
> physical 24TB drive, so best if there is a pin-pointed to test to
> reproduce the issue.
> 
> Best regards,
> Rabeeh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

