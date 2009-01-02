From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: confusion in validation of rec_len in ext2_add_link
Date: Fri, 2 Jan 2009 12:54:30 +0530
Message-ID: <ea11fea30901012324r511131f9r13ab09dc76370196@mail.gmail.com>
References: <ea11fea30812292145n2f484706refbe7bebaeb44e77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
	Linux-Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:57535 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZABHYe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Jan 2009 02:24:34 -0500
Received: by ti-out-0910.google.com with SMTP id b6so8759935tic.23
        for <linux-ext4@vger.kernel.org>; Thu, 01 Jan 2009 23:24:31 -0800 (PST)
In-Reply-To: <ea11fea30812292145n2f484706refbe7bebaeb44e77@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 30, 2008 at 11:15 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> Hi,
>
> I was trying to understand the purpose of the below check for
> validating rec_len in the function ext2_add_link(). Before reaching
> line 515 we call ext2_get_page() which checks for valid entries on the
> page and thus validates the rec_len too. And then we call the
> lock_page(), so is this check redundant

Got the answer here
http://lkml.indiana.edu/hypermail/linux/kernel/0204.1/0440.html

Thanks -
Manish

> or to avoid cases when
> something could have changed on the page between the lines 497 and 501
> ?
>
> ext2_add_link() {
>
> ........
> 497            page = ext2_get_page(dir, n, 0);
> 499                     if (IS_ERR(page))
> 500                     goto out;
> 501                 lock_page(page);
> .........
> 515                     if (de->rec_len == 0) {
> 516                             ext2_error(dir->i_sb, __func__,
> 517                                     "zero-length directory entry");
> 518                             err = -EIO;
> 519                             goto out_unlock;
> 520                     }
>
> ..........
> }
>
> Thanks -
> Manish
>
