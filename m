From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 2/2] ext4, project: fix typo comments for quota credits reservation
Date: Sun, 6 Aug 2017 21:01:45 +0800
Message-ID: <CAP9B-Qn8gfTxN_xe+gZ6ET9RwZ_n6g0_+YA4wCX9NDaYibFnsQ@mail.gmail.com>
References: <20170630035253.63358-1-wshilong@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Li Xi <lixi@ddn.com>, adilger@dilger.ca,
        Wang Shilong <wshilong@ddn.com>,
        Shuichi Ihara <sihara@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:37613 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdHFNBq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Aug 2017 09:01:46 -0400
Received: by mail-yw0-f196.google.com with SMTP id s143so3465006ywg.4
        for <linux-ext4@vger.kernel.org>; Sun, 06 Aug 2017 06:01:46 -0700 (PDT)
In-Reply-To: <20170630035253.63358-1-wshilong@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

how about this small typo fix. ^_^

On Fri, Jun 30, 2017 at 11:52 AM, Wang Shilong
<wangshilong1991@gmail.com> wrote:
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/ext4/ext4_jbd2.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index f976111..6dd20c8 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -43,10 +43,10 @@
>  #define EXT4_XATTR_TRANS_BLOCKS                6U
>
>  /* Define the minimum size for a transaction which modifies data.  This
> - * needs to take into account the fact that we may end up modifying two
> - * quota files too (one for the group, one for the user quota).  The
> - * superblock only gets updated once, of course, so don't bother
> - * counting that again for the quota updates. */
> + * needs to take into account the fact that we may end up modifying three
> + * quota files too (one for the group, one for the user quota, one for the
> + * project).  The superblock only gets updated once, of course, so don't
> + * bother counting that again for the quota updates. */
>
>  #define EXT4_DATA_TRANS_BLOCKS(sb)     (EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + \
>                                          EXT4_XATTR_TRANS_BLOCKS - 2 + \
> --
> 2.9.3
>
