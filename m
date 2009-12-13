From: Dmitry Monakhov <rjevskiy@gmail.com>
Subject: Please ignore all my previous messges
Date: Sun, 13 Dec 2009 11:25:43 +0300
Message-ID: <c18d6aa20912130025w775d8dfvcbdd19507c30ce5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47447 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751668AbZLMIZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Dec 2009 03:25:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello. I'm really sorry. My default smtp server was dead, so i've used
alternative.
This result in unexpected problems with mail delivery :(
Please ignore my spam. Again sorry.

2009/12/12 Dmitry Monakhov <dmonakhov@openvz.org>:
> Quota code requires unlocked version of this function. Off course
> we can just copy-paste the code, but copy-pasting is always an evil.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> =C2=A0fs/stat.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 10 +++++++=
+--
> =C2=A0include/linux/fs.h | =C2=A0 =C2=A01 +
> =C2=A02 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/stat.c b/fs/stat.c
> index 075694e..c4ecd52 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -401,9 +401,9 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, char __user =
*, filename,
> =C2=A0}
> =C2=A0#endif /* __ARCH_WANT_STAT64 */
>
> -void inode_add_bytes(struct inode *inode, loff_t bytes)
> +/* Caller is here responsible for sufficient locking (ie. inode->i_l=
ock) */
> +void __inode_add_bytes(struct inode *inode, loff_t bytes)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 spin_lock(&inode->i_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_blocks +=3D bytes >> 9;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0bytes &=3D 511;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_bytes +=3D bytes;
> @@ -411,6 +411,12 @@ void inode_add_bytes(struct inode *inode, loff_t=
 bytes)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_block=
s++;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode->i_bytes=
 -=3D 512;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +}
> +
> +void inode_add_bytes(struct inode *inode, loff_t bytes)
> +{
> + =C2=A0 =C2=A0 =C2=A0 spin_lock(&inode->i_lock);
> + =C2=A0 =C2=A0 =C2=A0 __inode_add_bytes(inode, bytes);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&inode->i_lock);
> =C2=A0}
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2620a8c..98ea200 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2314,6 +2314,7 @@ extern const struct inode_operations page_symli=
nk_inode_operations;
> =C2=A0extern int generic_readlink(struct dentry *, char __user *, int=
);
> =C2=A0extern void generic_fillattr(struct inode *, struct kstat *);
> =C2=A0extern int vfs_getattr(struct vfsmount *, struct dentry *, stru=
ct kstat *);
> +void __inode_add_bytes(struct inode *inode, loff_t bytes);
> =C2=A0void inode_add_bytes(struct inode *inode, loff_t bytes);
> =C2=A0void inode_sub_bytes(struct inode *inode, loff_t bytes);
> =C2=A0loff_t inode_get_bytes(struct inode *inode);
> --
> 1.6.0.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
