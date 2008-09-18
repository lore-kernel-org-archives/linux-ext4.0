From: "Eugene Teo" <eugeneteo@kernel.sg>
Subject: Re: [PATCH 3/4] ext2: Avoid printk floods in the face of directory corruption
Date: Thu, 18 Sep 2008 17:46:55 +0800
Message-ID: <28fa9c5e0809180246g3af92d31nfee5bfd765a57bb7@mail.gmail.com>
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
	 <1221319971-29879-2-git-send-email-tytso@mit.edu>
	 <1221319971-29879-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Eric Sandeen" <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42539 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYIRJq4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2008 05:46:56 -0400
Received: by gxk9 with SMTP id 9so30970001gxk.13
        for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2008 02:46:55 -0700 (PDT)
In-Reply-To: <1221319971-29879-3-git-send-email-tytso@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 11:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
[...]
>  Eend:
> -       p = (ext2_dirent *)(kaddr + offs);
> -       ext2_error (sb, "ext2_check_page",
> -               "entry in directory #%lu spans the page boundary"
> -               "offset=%lu, inode=%lu",
> -               dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
> -               (unsigned long) le32_to_cpu(p->inode));
> +       if (!quiet) {
> +               p = (ext2_dirent *)(kaddr + offs);
> +               ext2_error (sb, "ext2_check_page",
                                                ^^^^^^^^^^^^^^^^^^
> +                       "entry in directory #%lu spans the page boundary"
> +                       "offset=%lu, inode=%lu",
> +                       dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
> +                       (unsigned long) le32_to_cpu(p->inode));

Minor issue. Since you are already changing "ext2_check_page" to
__func__, you might as well change it here too.

Thanks, Eugene
