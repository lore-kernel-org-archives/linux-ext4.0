From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: ext4: Replace BUG_ON() with ext4_error() in move_extents.c
Date: Fri, 26 Oct 2012 17:07:24 +0900
Message-ID: <508A44BC.5040002@rs.jp.nec.com>
References: <20121025113503.GA7836@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:54589 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2JZINz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 04:13:55 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id q9Q8DrVE012549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2012 17:13:53 +0900 (JST)
In-Reply-To: <20121025113503.GA7836@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Dan,

Thanks for reporting,
this patch removes smatch warning.

Signed-off-by: Akria Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 292daee..17d28a1 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -680,6 +680,10 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,

        depth = ext_depth(donor_inode);
        dext = donor_path[depth].p_ext;
+       if (unlikely(!dext)) {
+               *err = -EIO;
+               goto out;
+       }
        tmp_dext = *dext;

        *err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,

Regards,
Akira Fujita

(2012/10/25 20:35), Dan Carpenter wrote:
> Hello Akira Fujita,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 2147b1a6a48e: "ext4: Replace BUG_ON() with ext4_error() in
> move_extents.c" from Sep 16, 2009, leads to the following Smatch
> complaint:
> 
> fs/ext4/move_extent.c:693 mext_replace_branches()
> 	 warn: variable dereferenced before check 'dext' (see line 683)
> 
> fs/ext4/move_extent.c
>     682		dext = donor_path[depth].p_ext;
>     683		tmp_dext = *dext;
>                             ^^^^^
> Old dereference.
> 
>     684	
>     685		*err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
>     686					      donor_off, count);
>     687		if (*err)
>     688			goto out;
>     689	
>     690		/* Loop for the donor extents */
>     691		while (1) {
>     692			/* The extent for donor must be found. */
>     693			if (!dext) {
>                              ^^^^^
> This check was inside BUG_ON() macro before and so Smatch ignored it on
> the basis that macros do a lot of unneeded checks.  But now it's outside
> the macro it triggers a warning.
> 
>     694				EXT4_ERROR_INODE(donor_inode,
>     695					   "The extent for donor must be found");
> 
> regards,
> dan carpenter
> 
> 
