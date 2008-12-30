From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: confusion in validation of rec_len in ext2_add_link
Date: Tue, 30 Dec 2008 11:15:51 +0530
Message-ID: <ea11fea30812292145n2f484706refbe7bebaeb44e77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	Linux-Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:35070 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYL3Fpx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Dec 2008 00:45:53 -0500
Received: by ti-out-0910.google.com with SMTP id b6so7944123tic.23
        for <linux-ext4@vger.kernel.org>; Mon, 29 Dec 2008 21:45:51 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was trying to understand the purpose of the below check for
validating rec_len in the function ext2_add_link(). Before reaching
line 515 we call ext2_get_page() which checks for valid entries on the
page and thus validates the rec_len too. And then we call the
lock_page(), so is this check redundant or to avoid cases when
something could have changed on the page between the lines 497 and 501
?

ext2_add_link() {

........	
497            page = ext2_get_page(dir, n, 0);
499	        	if (IS_ERR(page))
500			goto out;
501		    lock_page(page);
.........
515			if (de->rec_len == 0) {
516				ext2_error(dir->i_sb, __func__,
517					"zero-length directory entry");
518				err = -EIO;
519				goto out_unlock;
520			}

..........
}

Thanks -
Manish
