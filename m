From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 8/8 v3] ext4: introduce lseek SEEK_DATA/SEEK_HOLE support
Date: Sat, 27 Oct 2012 23:30:50 +0800
Message-ID: <20121027153049.GA5483@gmail.com>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
 <1351257825-3701-9-git-send-email-wenqing.lz@taobao.com>
 <508BB207.1010506@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	lczerner@redhat.com, Zheng Liu <wenqing.lz@taobao.com>
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49389 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab2J0PTl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Oct 2012 11:19:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so2530152pad.19
        for <linux-ext4@vger.kernel.org>; Sat, 27 Oct 2012 08:19:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508BB207.1010506@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 27, 2012 at 06:05:59PM +0800, Jeff Liu wrote:
[snip]
> >Jeff, I really appreicate if you could allow me to add Signed-off-by in this
> >patch.  Please let me know if you think it is not well.  Thanks!
> I'm fine. :)

Thank you. :-)

> Finally, maybe I'll try to tweak that routine with page cache lookup
> for unwritten extents to be a
> VFS helper so that Btrfs can make use of it as well, thank you!

That would be great.  I am glad to use it in ext4 as well.

Regards,
Zheng
