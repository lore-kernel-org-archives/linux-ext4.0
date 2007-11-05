From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [2.6 patch] ext4/super.c: fix #ifdef's
Date: Mon, 05 Nov 2007 15:09:43 -0800
Message-ID: <1194304183.3987.13.camel@localhost.localdomain>
References: <20071105170713.GJ12045@stusta.de>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Robert P. J. Day" <rpjday@crashcourse.ca>, tytso@mit.edu
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48900 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbXKEXJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 18:09:45 -0500
In-Reply-To: <20071105170713.GJ12045@stusta.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Acked-by: Mingmming Cao <cmm@us.ibm.com>

Ted, I added this patch in ext4 patch queue.

On Mon, 2007-11-05 at 18:07 +0100, Adrian Bunk wrote:
> This patch fixes the names of two variables in #ifdef's.
> 
> Based on a report by Robert P. J. Day.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  fs/ext4/super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 44e9889e6a3952ea225704b2e494d31e00f34a6b 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8031dc0..6673672 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -646,7 +646,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_puts(seq, ",debug");
>  	if (test_opt(sb, OLDALLOC))
>  		seq_puts(seq, ",oldalloc");
> -#ifdef CONFIG_EXT4_FS_XATTR
> +#ifdef CONFIG_EXT4DEV_FS_XATTR
>  	if (test_opt(sb, XATTR_USER))
>  		seq_puts(seq, ",user_xattr");
>  	if (!test_opt(sb, XATTR_USER) &&
> @@ -654,7 +654,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
>  		seq_puts(seq, ",nouser_xattr");
>  	}
>  #endif
> -#ifdef CONFIG_EXT4_FS_POSIX_ACL
> +#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
>  	if (test_opt(sb, POSIX_ACL))
>  		seq_puts(seq, ",acl");
>  	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
