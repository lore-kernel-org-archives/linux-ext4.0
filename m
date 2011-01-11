From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: fix memory leak in ext4_free_branches
Date: Tue, 11 Jan 2011 12:16:51 +0200
Message-ID: <AANLkTi=F=xZOechouoF+MRj8sZkvCDL3vfvG=SEwwQ6f@mail.gmail.com>
References: <20110110175234.GD3128@thunk.org>
	<1294682207-10494-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	hughd@google.com, stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46249 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1AKKQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jan 2011 05:16:52 -0500
Received: by qwa26 with SMTP id 26so20768627qwa.19
        for <linux-ext4@vger.kernel.org>; Tue, 11 Jan 2011 02:16:51 -0800 (PST)
In-Reply-To: <1294682207-10494-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 10, 2011 at 7:56 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Commit 40389687 moved a call to ext4_forget() out of
> ext4_free_branches and let ext4_free_blocks() handle calling
> bforget(). =A0But that change unfortunately did not replace the call =
to
> ext4_forget() with brelse(), which was needed to drop the in-use coun=
t
> of the indirect block's buffer head, which lead to a memory leak when
> deleting files that used indirect blocks. =A0Fix this.

My bad... what I should have done was to pass 'bh' to ext4_free_blocks.
this would make the code equivalent to ext3 code.

Ted's fix is probably as good, but I think it is nicer to fix it by pas=
sing bh.

>
> Thanks to Hugh Dickins for pointing this out.
>
> Cc: stable@kernel.org
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/inode.c | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 84b6162..e80fc51 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4378,6 +4378,7 @@ static void ext4_free_branches(handle_t *handle=
, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(__le32 *) bh->b_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0(__le32 *) bh->b_data + addr_per_block,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0depth);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 brelse(bh);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Everything below th=
is this pointer has been
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
