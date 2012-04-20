From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Fri, 20 Apr 2012 17:59:56 +0800
Message-ID: <20120420095956.GB30070@gmail.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
 <4F8DAAFE.40500@redhat.com>
 <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
 <alpine.LFD.2.00.1204181015050.5310@dhcp-27-109.brq.redhat.com>
 <20120418124811.GD3447@gmail.com>
 <341F6DCC-1788-4ACC-A86E-A5D99CC05320@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54721 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab2DTJxV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2012 05:53:21 -0400
Content-Disposition: inline
In-Reply-To: <341F6DCC-1788-4ACC-A86E-A5D99CC05320@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 18, 2012 at 08:09:02AM -0700, Andreas Dilger wrote:
> Looking at these performance numbers again, it would seem better if ext4 _was_ zero filling the whole file and converting the whole thing to initialized extents instead of leaving so many uninitialized extents behind.
> 
> The file size is 256MB, and the disk would have to be doing only 3.5MB/s for linear streaming writes to match the performance that you report, so a modern disk doing 50MB/s should be able to zero the whole file in 5s.
> 
> It seems the threshold for zeroing uninitialized extents is incorrect. EXT4_EXT_ZERO_LEN is only 7 blocks (28kB normally), but typical disks can write 64kB as easily as 4kB, so it would be interesting to change EXT4_EXT_ZERO_LEN to 16 and re-run your test. 
> 
> If that solves this particular test case, it wont necessarily the general case, but is still a useful fix.  If you submit a patch for this, please change this code to compare against 64kB instead of a block count, and also to take s_raid_stride into account if set, like:
> 
>         ext_zero_len = max(EXT4_EXT_ZERO_LEN * 1024 >> inode->i_blkbits,
>                            EXT4_SB(inode->i_sb)->s_es->s_raid_stride);
> 
> This would write up to 64kB, or a full RAID stripe (since it already needs to seek that spindle), whichever is larger.  It isn't perfect, since it should really align the zero-out to the RAID stripe to avoid seeking two spindles, but it is a starting point. 

Hi Andreas,

I set EXT4_EXT_ZERO_LEN to 16 and run the same benchmark again.  the result
is the same as before.

I notice this commit (3977c965) and it set EXT4_EXT_ZERO_LEN to 7.  But
in commit log, it doesn't describe why this value is set to 7.  As you
said, I believe that the disk writes 64K as easily as as 4k in modern
disk.  So maybe we can consider to set it to 16 or RAID stripe. :)

Regards,
Zheng
