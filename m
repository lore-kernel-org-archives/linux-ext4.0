From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] shared: test mount needs_recovery extN partition with
 noload option
Date: Thu, 24 Dec 2015 16:10:10 +0800
Message-ID: <20151224081010.GI2535@eguan.usersys.redhat.com>
References: <1450942226-19882-1-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	dmonakhov@openvz.org
To: Xiong Zhou <xzhou@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450942226-19882-1-git-send-email-xzhou@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 24, 2015 at 03:30:26PM +0800, Xiong Zhou wrote:
> Once upon a time, ext4 encounter NULL pointer dereference under this
> situaiton due to jump to a wrong label. Part of this commit fixed
> this Oops:
> 
> 744692d ext4: use ext4_get_block_write in buffer write
> 
> We can also run this test on ext2/3. Note that fsck will fail on
> ext2 due to:
>  "Superblock needs_recovery flag is set, but no journal is present"

I don't think fsck is needed in this test, superblock is modified on
purpose and ext2 always fails the check. So changing _require_scratch to
_require_scratch_nocheck would be good.

Otherwise looks good to me.

Thanks,
Eryu
