From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Fwd: [RESEND PATCH 2/2] ext4: ext4_inode_is_fast_symlink should
 use cluster size
Date: Mon, 23 Dec 2013 10:17:04 -0200
Message-ID: <20131223121703.GA4284@orion.maiolino.org>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com>
 <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3LWMRJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 07:17:09 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBNCH8js003608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 07:17:09 -0500
Received: from orion.maiolino.org (ovpn-113-60.phx2.redhat.com [10.3.113.60])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id rBNCH5o6027942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 07:17:08 -0500
Content-Disposition: inline
In-Reply-To: <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 20, 2013 at 01:13:33PM +0800, Yongqiang Yang wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.
> 
> Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9115f28..1869fcf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -145,7 +145,7 @@ static int ext4_meta_trans_blocks(struct inode
> *inode, int lblocks,
>  static int ext4_inode_is_fast_symlink(struct inode *inode)
>  {
>         int ea_blocks = EXT4_I(inode)->i_file_acl ?
> -               (inode->i_sb->s_blocksize >> 9) : 0;
> +                       EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;

Code looks good, but looks like it has an extra TAB here. Just a cosmetic thing;
despite that, consider it

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


-- 
Carlos
