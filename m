From: Li Haifeng <omycle@gmail.com>
Subject: Re: [PATCH] fix the outdated comment in ext2_nfs_get_inode()
Date: Wed, 31 Aug 2011 10:06:31 +0800
Message-ID: <CAFNq8R5GqbAcFmc+EgbFO63BCrvQQ4WCB+_LhPRJ=vR9g4CdGw@mail.gmail.com>
References: <CAFNq8R7dt03bXJUe4gVcZOGRSqJ7uPJHTFeXoaGTu2pKuNBCfw@mail.gmail.com>
	<20110830153944.GF16202@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42479 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1HaCGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 22:06:31 -0400
In-Reply-To: <20110830153944.GF16202@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, Jan.

2011/8/30 Jan Kara <jack@suse.cz>:
> On Tue 30-08-11 20:11:28, Li Haifeng wrote:
>> I am sorry, the last patch "fix the outdated comment in
>> ext2_nfs_get_inode()" has some " whitespace errors detected". So
>> correct it and remake it.
>>
>> I will be more careful later.
> =A0Hmm, your patch still has mangled whitespaces and wrapped long lin=
es.
> Please make sure your mailer doesn't do it or use git send-email to s=
end
> patches. Also the subject line misses "ext2:" in the beginning (after
> [PATCH]). Finally, I've further changed the text in the comment becau=
se
> "And" does not really make sense in that context to me. The patch I n=
ow
> carry in my tree is below.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
>
> From 8e871fa6a2db8ec615614e547d95de21f9045a52 Mon Sep 17 00:00:00 200=
1
> From: Li Haifeng <omycle@gmail.com>
> Date: Tue, 30 Aug 2011 17:32:50 +0200
> Subject: [PATCH] ext2: fix the outdated comment in ext2_nfs_get_inode=
()
>
> Signed-off-by: Li Haifeng <omycle@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =A0fs/ext2/super.c | =A0 =A08 ++++----
> =A01 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 174782f..adf3cde 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -327,10 +327,10 @@ static struct inode *ext2_nfs_get_inode(struct =
super_block *sb,
> =A0 =A0 =A0 =A0if (ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_coun=
t))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ERR_PTR(-ESTALE);
>
> - =A0 =A0 =A0 /* iget isn't really right if the inode is currently un=
allocated!!
> - =A0 =A0 =A0 =A0* ext2_read_inode currently does appropriate checks,=
 but
> - =A0 =A0 =A0 =A0* it might be "neater" to call ext2_get_inode first =
and check
> - =A0 =A0 =A0 =A0* if the inode is valid.....
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* ext2_iget isn't quite right if the inode is curren=
tly unallocated!
> + =A0 =A0 =A0 =A0* However ext2_iget currently does appropriate check=
s to handle stale
> + =A0 =A0 =A0 =A0* inodes so everything is OK.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0inode =3D ext2_iget(sb, ino);
> =A0 =A0 =A0 =A0if (IS_ERR(inode))
> --
> 1.7.1
>



--=20
Li Haifeng
Laboratory of Service Computing Technology and System
Home page:http://tek-life.org
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
