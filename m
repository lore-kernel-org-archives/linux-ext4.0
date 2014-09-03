From: Yuanhan Liu <yliu.null@gmail.com>
Subject: Re: [PATCH 1/2] jbd2: don't call get_bh() before calling __jbd2_journal_remove_checkpoint()
Date: Wed, 3 Sep 2014 15:54:39 +0800
Message-ID: <CAGZGoEd0TcJccE-RAZ1+mevWJiWE-Fm1AVeN8=-GiZHg-O38pg@mail.gmail.com>
References: <20140902215930.GJ6232@thunk.org>
	<1409698000-18126-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37896 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaICHyj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Sep 2014 03:54:39 -0400
Received: by mail-vc0-f173.google.com with SMTP id im17so8335322vcb.18
        for <linux-ext4@vger.kernel.org>; Wed, 03 Sep 2014 00:54:39 -0700 (PDT)
In-Reply-To: <1409698000-18126-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

<resend due to malformed email>

On Wed, Sep 3, 2014 at 6:46 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> The __jbd2_journal_remove_checkpoint() doesn't require an elevated
> b_count; indeed, until the jh structure gets released by the call to
> jbd2_journal_put_journal_head(), the bh's b_count is elevated by
> virtue of the existence of the jh structure.
>
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/jbd2/checkpoint.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 22fcd50..cb6e17c 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -100,11 +100,8 @@ static int __try_to_free_cp_buf(struct journal_head *jh)
>                  * Get our reference so that bh cannot be freed before
>                  * we unlock it
>                  */

I guess you need drop those comments as well.

        --yliu
> -               get_bh(bh);
>                 JBUFFER_TRACE(jh, "remove from checkpoint list");
>                 ret = __jbd2_journal_remove_checkpoint(jh) + 1;
> -               BUFFER_TRACE(bh, "release");
> -               __brelse(bh);
>         }
>         return ret;
