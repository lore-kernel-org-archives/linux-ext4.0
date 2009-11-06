From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext4: journal all modifications in ext4_xattr_set_handle
Date: Fri, 06 Nov 2009 16:35:11 -0600
Message-ID: <4AF4A49F.8030005@redhat.com>
References: <4AF4A334.1000304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760508AbZKFWfJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 17:35:09 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nA6MZETi032579
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 17:35:15 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nA6MZBIS006243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 17:35:14 -0500
In-Reply-To: <4AF4A334.1000304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> ext4_xattr_set_handle() was modifying s_inode_size outside
> of journaling constraints; this is one of the accesses that
> was causing the crc errors in journal replay as seen in
> kernel.org bugzilla #14354.

Oh, and for those who haven't been following the bug, big
thanks to Chris Mason for helping to look into this and coming
up with the debugging patch that made it obvious...

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index fed5b01..0257019 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -988,6 +988,10 @@ ext4_xattr_set_handle(handle_t *handle, struct 
> inode *inode, int name_index,
>     if (error)
>         goto cleanup;
> 
> +    error = ext4_journal_get_write_access(handle, is.iloc.bh);
> +    if (error)
> +        goto cleanup;
> +
>     if (EXT4_I(inode)->i_state & EXT4_STATE_NEW) {
>         struct ext4_inode *raw_inode = ext4_raw_inode(&is.iloc);
>         memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
> @@ -1013,9 +1017,6 @@ ext4_xattr_set_handle(handle_t *handle, struct 
> inode *inode, int name_index,
>         if (flags & XATTR_CREATE)
>             goto cleanup;
>     }
> -    error = ext4_journal_get_write_access(handle, is.iloc.bh);
> -    if (error)
> -        goto cleanup;
>     if (!value) {
>         if (!is.s.not_found)
>             error = ext4_xattr_ibody_set(handle, inode, &i, &is);
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

