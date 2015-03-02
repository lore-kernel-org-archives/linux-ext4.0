From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] ext4: fix transposition typo in format string
Date: Mon, 02 Mar 2015 10:55:41 +0100
Message-ID: <878uffhgf6.fsf@rasmusvillemoes.dk>
References: <1424441495-32581-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:40178 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbbCBJzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2015 04:55:44 -0500
Received: by labgd6 with SMTP id gd6so29151843lab.7
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2015 01:55:43 -0800 (PST)
In-Reply-To: <1424441495-32581-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Fri, 20 Feb 2015 15:11:35 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ping... (maybe I should have used a more dramatic subject - I do think
this is a real bug, but if not, I'd still like to get an explicit NAK.)

On Fri, Feb 20 2015, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> According to C99, %*.s means the same as %*.0s, in other words, print
> as many spaces as the field width argument says and effectively ignore
> the string argument. That is certainly not what was meant here. The
> kernel's printf implementation, however, treats it as if the . was not
> there, i.e. as %*s. I don't know if de->name is nul-terminated or not,
> but in any case I'm guessing the intention was to use de->name_len as
> precision instead of field width.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> If de->name is not guaranteed to be nul-terminated, I suppose this is
> even -stable material.
>
>  fs/ext4/inline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 4b143febf21f..8b64d715e476 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -972,7 +972,7 @@ void ext4_show_inline_dir(struct inode *dir, struct buffer_head *bh,
>  	offset = 0;
>  	while ((void *)de < dlimit) {
>  		de_len = ext4_rec_len_from_disk(de->rec_len, inline_size);
> -		trace_printk("de: off %u rlen %u name %*.s nlen %u ino %u\n",
> +		trace_printk("de: off %u rlen %u name %.*s nlen %u ino %u\n",
>  			     offset, de_len, de->name_len, de->name,
>  			     de->name_len, le32_to_cpu(de->inode));
>  		if (ext4_check_dir_entry(dir, NULL, de, bh,
