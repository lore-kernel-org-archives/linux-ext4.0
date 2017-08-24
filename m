From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: fix incorrect quotaoff if the quota feature is
 enabled
Date: Thu, 24 Aug 2017 15:20:42 -0400
Message-ID: <20170824192042.jxcwte2qouetd5tr@thunk.org>
References: <1503479638-16977-1-git-send-email-yi.zhang@huawei.com>
 <20170823100000.GC2100@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51446 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdHXTUr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 15:20:47 -0400
Content-Disposition: inline
In-Reply-To: <20170823100000.GC2100@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 23, 2017 at 12:00:00PM +0200, Jan Kara wrote:
> On Wed 23-08-17 17:13:57, zhangyi (F) wrote:
> > Current ext4 quota should always "usage enabled" if the
> > quota feautre is enabled. But in ext4_orphan_cleanup(), it
> > turn quotas off directly (used for the older journaled
> > quota), so we cannot turn it on again via "quotaon" unless
> > umount and remount ext4.
> > 
> > Simple reproduce:
> > 
> >   mkfs.ext4 -O project,quota /dev/vdb1
> >   mount -o prjquota /dev/vdb1 /mnt
> >   chattr -p 123 /mnt
> >   chattr +P /mnt
> >   touch /mnt/aa /mnt/bb
> >   exec 100<>/mnt/aa
> >   rm -f /mnt/aa
> >   sync
> >   echo c > /proc/sysrq-trigger
> > 
> >   #reboot and mount
> >   mount -o prjquota /dev/vdb1 /mnt
> >   #query status
> >   quotaon -Ppv /dev/vdb1
> >   #output
> >   quotaon: Cannot find mountpoint for device /dev/vdb1
> >   quotaon: No correct mountpoint specified.
> > 
> > This patch add check for journaled quotas to avoid incorrect
> > quotaoff when ext4 has quota feautre.
> > 
> > Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
