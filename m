From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: update ctime and mtime for truncate with extents.
Date: Thu, 10 Apr 2008 07:14:47 -0700
Message-ID: <1207836888.6172.2.camel@localhost.localdomain>
References: <Pine.LNX.4.62.0804030034200.664@tamago.serverit.net>
	 <18425.57003.125097.61814@frecb006361.adech.frec.bull.fr>
	 <1207802397.3616.4.camel@localhost.localdomain>
	 <18430.4635.195999.326984@frecb006361.adech.frec.bull.fr>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Szabolcs Szakacsits <szaka@ntfs-3g.com>
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59630 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbYDJOOs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2008 10:14:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3AEGqr4029075
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 10:16:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3AEElUd114564
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 10:14:47 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3AEElC3021912
	for <linux-ext4@vger.kernel.org>; Thu, 10 Apr 2008 10:14:47 -0400
In-Reply-To: <18430.4635.195999.326984@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-04-10 at 15:11 +0200, Solofo.Ramangalahy@bull.net wrote:
> Mingming Cao writes:
>  > Shouldn't we mark inode dirty after the ctime and and mtime is changed?
> 
> I should have been more careful when mimicing the non-extent case or
> examine more closely the patch queue (I am just noticing
> ext4-update-mtime-and-ctime-on-rename.patch). I honestly do not have
> a definitive answer now, but I trust you and Jan more than me.
> 
> ... so, yes, we should.
> 
> Looking back at the code, there is actually a pattern
> ext4_current_time() followed by ext4_mark_inode_dirty(), but I do not
> think it is worth a refactoring.
> 
> Attached the updated patch.
> 
> Thanks and sorry for the trouble,

Np, I updated the patch in the patch queue. BTW, it would be nice to
generate the patch with -p next time to show which function the changes
are modifying.

Mingming
> --
> solofo
> 
> ext4: update ctime and mtime for truncate with extents.
> 
> From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> 
> The recently announced "Linux POSIX file system test suite"
> http://ntfs3g.org/sw/qa/pjd-fstest-20080402.tgz catched a truncate
> issue when using extents:
> mtime and ctime are not updated despite truncate being successful.
> 
> This is the single issue catched with "default" ext4 (mkfs and mount
> with minimal options).
> The testsuite does not report failure with -o noextents.
> 
> With the following patch, all tests of the testsuite passes:
> 
> Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> 
> ---
>  fs/ext4/extents.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/extents.c
> ===================================================================
> --- linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d.orig/fs/ext4/extents.c
> +++ linux-2.6.25-rc8-git5-ext4-52c7a8013ad2c452551a68ff4daab4bacbe28f9d/fs/ext4/extents.c
> @@ -2947,6 +2947,8 @@ out_stop:
>                 ext4_orphan_del(handle, inode);
> 
>         up_write(&EXT4_I(inode)->i_data_sem);
> +       inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> +       ext4_mark_inode_dirty(handle, inode);
>         ext4_journal_stop(handle);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

