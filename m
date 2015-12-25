From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] shared: test mount needs_recovery extN partition with
 noload option
Date: Fri, 25 Dec 2015 12:30:52 +0800
Message-ID: <20151225043052.GC24476@eguan.usersys.redhat.com>
References: <20151224081010.GI2535@eguan.usersys.redhat.com>
 <1451010049-14761-1-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	dmonakhov@openvz.org
To: Xiong Zhou <xzhou@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451010049-14761-1-git-send-email-xzhou@redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 25, 2015 at 10:20:49AM +0800, Xiong Zhou wrote:
> Once upon a time, ext4 encounter NULL pointer dereference under this
> situaiton due to jump to a wrong label. Part of this commit fixed
> this Oops:
> 
> 744692d ext4: use ext4_get_block_write in buffer write
> 
> We can also run this test on ext2/3.
> 
> This case is based on a script from Monakhov Dmitriy @ openvz.
> 
> Cc: Monakhov Dmitriy <dmonakhov@openvz.org>
> Signed-off-by: Xiong Zhou <xzhou@redhat.com>

Looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>
