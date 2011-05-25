From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 14/19] ext3: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Wed, 25 May 2011 10:44:28 +0800
Message-ID: <BANLkTi=4wC9RCF+QQg0GP5bHM8X-71ckJg@mail.gmail.com>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
	<1306267582-5347-15-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40615 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab1EYCob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 22:44:31 -0400
In-Reply-To: <1306267582-5347-15-git-send-email-sage@newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Which kernel version is this patch based on?
Code in my working tree which is 2.6.39-rc3 is already same as the
code after the patch applied.

Thx!

Yongqiang.
On Wed, May 25, 2011 at 4:06 AM, Sage Weil <sage@newdream.net> wrote:
> ext3 has no problems with lingering references to unlinked directory
> inodes.
>
> CC: Jan Kara <jack@suse.cz>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andreas Dilger <adilger.kernel@dilger.ca>
> CC: linux-ext4@vger.kernel.org
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
> =A0fs/ext3/namei.c | =A0 =A05 -----
> =A01 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index f89b1d4..32f3b86 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -2074,8 +2074,6 @@ static int ext3_rmdir (struct inode * dir, stru=
ct dentry *dentry)
> =A0 =A0 =A0 =A0struct ext3_dir_entry_2 * de;
> =A0 =A0 =A0 =A0handle_t *handle;
>
> - =A0 =A0 =A0 dentry_unhash(dentry);
> -
> =A0 =A0 =A0 =A0/* Initialize quotas before so that eventual writes go=
 in
> =A0 =A0 =A0 =A0 * separate transaction */
> =A0 =A0 =A0 =A0dquot_initialize(dir);
> @@ -2298,9 +2296,6 @@ static int ext3_rename (struct inode * old_dir,=
 struct dentry *old_dentry,
> =A0 =A0 =A0 =A0struct ext3_dir_entry_2 * old_de, * new_de;
> =A0 =A0 =A0 =A0int retval, flush_file =3D 0;
>
> - =A0 =A0 =A0 if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode-=
>i_mode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry_unhash(new_dentry);
> -
> =A0 =A0 =A0 =A0dquot_initialize(old_dir);
> =A0 =A0 =A0 =A0dquot_initialize(new_dir);
>
> --
> 1.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
