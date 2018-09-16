From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 1/3] ext4: fix setattr project check upon
 fssetxattr ioctl
Date: Sat, 15 Sep 2018 23:55:29 -0400
Message-ID: <20180916035529.GG8652@thunk.org>
References: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org, wshilong@ddn.com,
 dchinner@redhat.com, linux-f2fs-devel@lists.sourceforge.net
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 12, 2018 at 08:57:16AM +0900, Wang Shilong wrote:
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index a7074115d6f6..f81102bd3203 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -339,19 +339,14 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
>  	if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
>  		return 0;
>  
> -	err = mnt_want_write_file(filp);
> -	if (err)
> -		return err;
> -

A huge part of this patch is dropping the calls to
mnt_want_write_file() and mnt_drop_write_file().  What's the
justification for doing this?  The use of mnt_want_write_file() looks
necessary to me...

				- Ted
