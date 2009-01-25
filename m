From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH] : make sure the buffer head members are zeroed out before
	using them.
Date: Sun, 25 Jan 2009 21:23:22 +0530
Message-ID: <ea11fea30901250753j6db5158dj9082d57aa9469685@mail.gmail.com>
References: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
	cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:40349 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZAYPx0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Jan 2009 10:53:26 -0500
Received: by ti-out-0910.google.com with SMTP id b6so3310059tic.23
        for <linux-ext4@vger.kernel.org>; Sun, 25 Jan 2009 07:53:23 -0800 (PST)
In-Reply-To: <ea11fea30901200906m4dfb5060ya82104519b4984bb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 20, 2009 at 10:36 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> ext2_quota_read doesn't bzeroes tmp_bh before calling ext2_get_block()
> where we access the b_size of it. Since it is a local variable it
> might contain some garbage. Make sure it is filled with zero before
> passing.

Hi Ted/mingming,

Any feedback on this ??

Thanks -
Manish

>
> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext2/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index da8bdea..d10aa44 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1327,7 +1327,7 @@ static ssize_t ext2_quota_read(struct
> super_block *sb, int type, char *data,
>                tocopy = sb->s_blocksize - offset < toread ?
>                                sb->s_blocksize - offset : toread;
>
> -               tmp_bh.b_state = 0;
> +               memset(&tmp_bh, 0, sizeof(struct buffer_head));
>                err = ext2_get_block(inode, blk, &tmp_bh, 0);
>                if (err < 0)
>                        return err;
> @@ -1366,7 +1366,7 @@ static ssize_t ext2_quota_write(struct
> super_block *sb, int type,
>                tocopy = sb->s_blocksize - offset < towrite ?
>                                sb->s_blocksize - offset : towrite;
>
> -               tmp_bh.b_state = 0;
> +               memset(&tmp_bh, 0, sizeof(struct buffer_head));
>                err = ext2_get_block(inode, blk, &tmp_bh, 1);
>                if (err < 0)
>                        goto out;
> --
> 1.5.4.3
>
>
> Thanks -
> Manish
>
