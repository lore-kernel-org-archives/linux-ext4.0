From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCHv2 03/12]posix_acl: Add the check items
Date: Mon, 21 Dec 2009 09:39:07 -0600
Message-ID: <20091221153907.GA30127@us.ibm.com>
References: <4B2F61D7.5000302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, jmorris@namei.org, joel.becker@oracle.com,
	hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, strongzgy@gmail.com,
	onlyflyer@gmail.com
To: Liuwenyi <qingshenlwy@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:48528 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZLUPjZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Dec 2009 10:39:25 -0500
Content-Disposition: inline
In-Reply-To: <4B2F61D7.5000302@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Liuwenyi (qingshenlwy@gmail.com):
> move the ACL validation check in to fs/posix_acl.c.
> Including nullpointer check and PTR_ERR check.
> 
> ---
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: James Morris <jmorris@namei.org>
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: Serge Hallyn <serue@us.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: linux-ext4@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> ---
> diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> index a99e543..480fe88 100644
> --- a/fs/ext2/acl.c
> +++ b/fs/ext2/acl.c
> @@ -403,13 +403,11 @@ ext2_xattr_set_acl(struct dentry *dentry, const
> char *name, const void *value,
> 
> if (value) {
> acl = posix_acl_from_xattr(value, size);
> - if (IS_ERR(acl))
> - return PTR_ERR(acl);
> - else if (acl) {
> - error = posix_acl_valid(acl);
> - if (error)
> - goto release_and_out;
> - }
> +
> + error = posix_acl_valid(acl);
> + if (error)
> + goto release_and_out;

Don't you also need to either update posix_acl_release() in your
first patch to handle IS_ERR(acl), or else update the release_and_out:
path in each caller?

> +
> } else
> acl = NULL;
> 
> 
> -- 
> Best Regards,
> Liuwenyi
