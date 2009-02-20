From: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory
	traversal through deleted inode
Date: Fri, 20 Feb 2009 12:53:39 -0500
Message-ID: <3e8340490902200953p704fd9dbuff0a7a890895ea23@mail.gmail.com>
References: <20090214141411.GD26628@mini-me.lan>
	 <1234833003-19631-1-git-send-email-bdonlan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
	tytso@mit.edu, Bryan Donlan <bdonlan@gmail.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:46914 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZBTRxk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2009 12:53:40 -0500
In-Reply-To: <1234833003-19631-1-git-send-email-bdonlan@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 16, 2009 at 8:10 PM, Bryan Donlan <bdonlan@gmail.com> wrote:

> +               if (unlikely(IS_ERR(inode))) {
> +                       if (PTR_ERR(inode) == -ESTALE) {
> +                               ext3_error(dir->i_sb, "ext2_lookup",
> +                                               "deleted inode referenced: %lu",
> +                                               ino);
> +                               return ERR_PTR(-EIO);
> +                       } else {
> +                               return ERR_CAST(inode);
> +                       }
> +               }

I just noticed that I forgot to edit the function name in the
ext3_error and ext4_error invocations... Would it be better to send a
delta to fix this or resubmit the whole thing?
