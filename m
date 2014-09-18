From: Dexuan Cui <decui@microsoft.com>
Subject: Is ext2 freezable?
Date: Thu, 18 Sep 2014 05:15:43 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99CE06F@SINEX14MBXC418.southpacific.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:5434
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751217AbaIRGtx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 02:49:53 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
I'm running "fsfreeze  --freeze /mnt" (/mnt is mounted with an ext2 partition)
and getting "fsfreeze: /mnt: freeze failed: Operation not supported":

the strace log shows:

open("/mnt", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
 ioctl(3, FIFREEZE, 0)             = -1 EOPNOTSUPP (Operation not supported)

My kernel is 3.16.2.
I know ext3/4 support fs freeze, but I'm not sure about ext2.

Though the above experiment shows it's not supported,  but I do see

struct super_operations ext2_sops defines an ext2_freeze() and the
code of ioctl_fsfreeze() is:

static int ioctl_fsfreeze(struct file *filp)
{
        struct super_block *sb = file_inode(filp)->i_sb;

        if (!capable(CAP_SYS_ADMIN))
                return -EPERM;

        /* If filesystem doesn't support freeze feature, return. */
        if (sb->s_op->freeze_fs == NULL)
                return -EOPNOTSUPP;

        /* Freeze */
        return freeze_super(sb);
}

It seems here sb->s_op->freeze_fs is NULL??? why?

I think I must miss something. Please point it out.

Thanks!

-- Dexuan

