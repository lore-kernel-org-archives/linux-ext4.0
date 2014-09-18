From: Dexuan Cui <decui@microsoft.com>
Subject: RE: Is ext2 freezable?
Date: Thu, 18 Sep 2014 06:46:21 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99CE2C3@SINEX14MBXC418.southpacific.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bn1bbn0104.outbound.protection.outlook.com ([157.56.111.104]:2784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751313AbaIRGqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 02:46:40 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> -----Original Message-----
> From: Dexuan Cui
> Sent: Thursday, September 18, 2014 13:16 PM
> To: linux-ext4@vger.kernel.org
> Subject: Is ext2 freezable?
> 
> Hi all,
> I'm running "fsfreeze  --freeze /mnt" (/mnt is mounted with an ext2 partition)
> and getting "fsfreeze: /mnt: freeze failed: Operation not supported":
> ...
> code of ioctl_fsfreeze() is:
> 
> static int ioctl_fsfreeze(struct file *filp)
> {
>         struct super_block *sb = file_inode(filp)->i_sb;
> 
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
> 
>         /* If filesystem doesn't support freeze feature, return. */
>         if (sb->s_op->freeze_fs == NULL)
>                 return -EOPNOTSUPP;
> 
>         /* Freeze */
>         return freeze_super(sb);
> }
> 
> It seems here sb->s_op->freeze_fs is NULL??? why?

I've got the answer:
ext2.ko itself does support fsfreeze, but typical linux distros don't supply
ext2.ko at all now -- instead, they usually supply ext3.ko and have ext4 builtin.

So when I mount an ext2 partition, actually the kernel is registering the ext4
driver as an ext2 driver and in this case the ext2's s_op->freeze_fs is NULL --
but, why did ext4 choose this behavior for ext2?

Thanks,
-- Dexuan
