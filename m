From: Javier Marcet <jmarcet@gmail.com>
Subject: Re: Far too long mount time
Date: Thu, 16 Aug 2012 11:18:31 +0200
Message-ID: <CAAnFQG9L4==6V6kHg=ms8_5adBUUCj0f92RQHAPdo8yac9XcdA@mail.gmail.com>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
 <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com> <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47144 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2HPJSv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 05:18:51 -0400
Received: by ggdk6 with SMTP id k6so2686466ggd.19
        for <linux-ext4@vger.kernel.org>; Thu, 16 Aug 2012 02:18:51 -0700 (PDT)
In-Reply-To: <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 11:09 AM, Andreas Dilger <adilger@dilger.ca> wrote:

>> I'm in the process of setting up a new software raid with four 3TB disks.
>> So far I'm doing the tests using also bcache on a 60GB partition on a 120GB
>> SSD. Everything is protected by a UPS.
>>
>> On the software side: self compiled kernel 3.5.1 and util-linux 2.20.1
>>
>> Thus far, ext4 is doing really really well but for one thing, the mount
>> time. At the moment I'm testing a RAID5 which makes the partition 8.2TB.
>>
>> ext4 takes:
>> $ time mount /mnt/raid
>> 0.00s user 79.49s system 92% cpu 1:26.25 total
>>
>> xfs, OTOH, is way faster:
>> time mount /mnt/raid
>> 0.00s user 0.01s system 0% cpu 1.869 total
>>
>> I'v tried everything I could think of but the mount time remains constant.
>> Is there anything I can do to speed up the mount time?
>
> Did you format the filesystem with "mke2fs -t ext4"?  Without the "-t ext4" option, you won't get the "flex_bg" formatting option, which improves the layout of the filesystem metadata, and definitely reduces mount times.

Hmm, I used mkfs.ext4. Loooking at /etc/mke2fs.conf :

defaults]
        base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
        default_mntopts = acl,user_xattr
        enable_periodic_fsck = 0
        blocksize = 4096
        inode_size = 256
        inode_ratio = 16384

[fs_types]
        ext3 = {
                features = has_journal
        }
        ext4 = {
                features =
has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
                auto_64-bit_support = 1
                inode_size = 256
        }

It looks like flex_bg is being used.

> It is a bit strange that _mounting_ uses 92% CPU.  Hmm, there was a bug
> reported for 3.5.1, see "Re: Upgraded from 3.4 to 3.5.1 kernel: machine

That also surprised me. At first I thought it was bcache, but with zfs the
behavior is normal.

> does not boot", and reverting the patch with git commit hash
> "8aeb00ff85ad25453765dd339b408c0087db1527" resolved the problem.  This
> slowdown was only seen with larger devices.

I'll check it right now.

I've reverted it and I'm compiling the new kernel. I'll keep you
posted on the results.

By the way, when you say larger, you mean much larger than 8TB?


-- 
Javier Marcet <jmarcet@gmail.com>
