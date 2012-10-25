From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: Replace BUG_ON() with ext4_error() in move_extents.c
Date: Thu, 25 Oct 2012 14:35:03 +0300
Message-ID: <20121025113503.GA7836@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: a-fujita@rs.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45011 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2JYLfL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 07:35:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Akira Fujita,

This is a semi-automatic email about new static checker warnings.

The patch 2147b1a6a48e: "ext4: Replace BUG_ON() with ext4_error() in 
move_extents.c" from Sep 16, 2009, leads to the following Smatch 
complaint:

fs/ext4/move_extent.c:693 mext_replace_branches()
	 warn: variable dereferenced before check 'dext' (see line 683)

fs/ext4/move_extent.c
   682		dext = donor_path[depth].p_ext;
   683		tmp_dext = *dext;
                           ^^^^^
Old dereference.

   684	
   685		*err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
   686					      donor_off, count);
   687		if (*err)
   688			goto out;
   689	
   690		/* Loop for the donor extents */
   691		while (1) {
   692			/* The extent for donor must be found. */
   693			if (!dext) {
                            ^^^^^
This check was inside BUG_ON() macro before and so Smatch ignored it on
the basis that macros do a lot of unneeded checks.  But now it's outside
the macro it triggers a warning.

   694				EXT4_ERROR_INODE(donor_inode,
   695					   "The extent for donor must be found");

regards,
dan carpenter

