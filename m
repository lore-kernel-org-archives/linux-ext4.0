From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH] ext4: don't free an error pointer
Date: Fri, 30 Jun 2017 04:17:58 -0700
Message-ID: <CAAeU0aN=qsJAHrmowwv499mkUCpTrA54yMdJP-NM8g7kZ3OFyQ@mail.gmail.com>
References: <20170630075652.gsvvzybinoee2biw@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170630075652.gsvvzybinoee2biw@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reviewed-by: Tahsin Erdogan <tahsin@google.com>

On Fri, Jun 30, 2017 at 12:56 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> "goto out;" calls brelse(bh); which will oops on this this path where
> "bh" is an error pointer.
>
> Fixes: 2851a40a5d71 ("ext4: xattr-in-inode support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Oops.  I wrote a bug report and a patch for this...  Probably we only
> need the patch.
>
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index ce12c3fb7e59..f7d6845e147b 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1305,10 +1305,8 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
>                 csize = (bufsize - wsize) > blocksize ? blocksize :
>                                                                 bufsize - wsize;
>                 bh = ext4_getblk(handle, ea_inode, block, 0);
> -               if (IS_ERR(bh)) {
> -                       ret = PTR_ERR(bh);
> -                       goto out;
> -               }
> +               if (IS_ERR(bh))
> +                       return PTR_ERR(bh);
>                 ret = ext4_journal_get_write_access(handle, bh);
>                 if (ret)
>                         goto out;
