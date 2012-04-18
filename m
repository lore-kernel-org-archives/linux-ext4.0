From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 08:09:02 -0700
Message-ID: <341F6DCC-1788-4ACC-A86E-A5D99CC05320@whamcloud.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAAFE.40500@redhat.com> <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com> <alpine.LFD.2.00.1204181015050.5310@dhcp-27-109.brq.redhat.com> <20120418124811.GD3447@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43352 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2DRPJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 11:09:39 -0400
Received: by pbcun15 with SMTP id un15so9055924pbc.19
        for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 08:09:39 -0700 (PDT)
In-Reply-To: <20120418124811.GD3447@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-18, at 5:48, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> I run a more detailed benchmark again.  The environment is as before,
> and the machine has Intel(R) Core(TM)2 Duo CPU E8400, 4G memory and a
> WDC WD1600AAJS-75M0A0 160G SATA disk.
> 
> I use 'fallocate' and 'dd' command to create a 256M file.  I compare
> three cases, which are fallocate w/o new flag, fallocate w/ new flag,
> and dd.  We use these commands to create a file.  Meanwhile w/ journal
> and w/o journal are compared.  When I format the filesytem, I use
> '-E lazy_itable_init=0' to avoid impact.  I use this command to do the
> comparsion:
> 
> time for((i=0;i<2000;i++)); \
>        do \
>        dd if=/dev/zero of=/mnt/sda1/testfile conv=notrunc bs=4k \
>        count=1 seek=`expr $i \* 16` oflag=sync,direct 2>/dev/null; \
>        done
> 
> 
> The result:
> 
> nojournal:
>        fallocte        dd              fallocate w/ new flag
> real    0m4.196s        0m3.720s        0m3.782s
> user    0m0.167s        0m0.194s        0m0.192s
> sys     0m0.404s        0m0.393s        0m0.390s
> 
> data=journal:
>        fallocate       dd              fallocate w/ new flag
> real    1m9.673s        1m10.241s       1m9.773s
> user    0m0.183s        0m0.205s        0m0.192s
> sys     0m0.397s        0m0.407s        0m0.398s
> 
> data=ordered
>        fallocate       dd              fallocate w/ new flag
> real    1m16.006s       0m18.291s       0m18.449s
> user    0m0.193s        0m0.193s        0m0.201s
> sys     0m0.384s        0m0.387s        0m0.381s
> 
> data=writeback
>        fallocate       dd              fallocate w/ new flag
> real    1m16.247s       0m18.133s       0m18.417s
> user    0m0.187s        0m0.193s        0m0.205s
> sys     0m0.401s        0m0.398s        0m0.387s
> 
> In journal mode, we can see, when data is set to 'journal', the result
> is almost the same.  However, when data is set 'ordered' or 'writeback',
> the slowdown in w/ conversion case is severe.  Then I do the same test
> without 'oflag=sync,direct', and the result doesn't change.  IMHO, I
> guess that journal is the *root cause*.  Until now, I don't have a
> definitely conclusion, and I will go on traing this issue.  Please feel
> free to comment it.

Looking at these performance numbers again, it would seem better if ext4 _was_ zero filling the whole file and converting the whole thing to initialized extents instead of leaving so many uninitialized extents behind.

The file size is 256MB, and the disk would have to be doing only 3.5MB/s for linear streaming writes to match the performance that you report, so a modern disk doing 50MB/s should be able to zero the whole file in 5s.

It seems the threshold for zeroing uninitialized extents is incorrect. EXT4_EXT_ZERO_LEN is only 7 blocks (28kB normally), but typical disks can write 64kB as easily as 4kB, so it would be interesting to change EXT4_EXT_ZERO_LEN to 16 and re-run your test. 

If that solves this particular test case, it wont necessarily the general case, but is still a useful fix.  If you submit a patch for this, please change this code to compare against 64kB instead of a block count, and also to take s_raid_stride into account if set, like:

        ext_zero_len = max(EXT4_EXT_ZERO_LEN * 1024 >> inode->i_blkbits,
                           EXT4_SB(inode->i_sb)->s_es->s_raid_stride);

This would write up to 64kB, or a full RAID stripe (since it already needs to seek that spindle), whichever is larger.  It isn't perfect, since it should really align the zero-out to the RAID stripe to avoid seeking two spindles, but it is a starting point. 

Cheers, Andreas

