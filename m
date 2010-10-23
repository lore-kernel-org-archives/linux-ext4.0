From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Committing changes to an ext3_inode structure
Date: Sat, 23 Oct 2010 18:48:29 +0200
Message-ID: <AANLkTinV0G_Bf4xc4F6XXivpjXJjkTAOgQ8rHsNts0FH@mail.gmail.com>
References: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Felipe Franciosi <felipe@paradoxo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58401 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0JWQsb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Oct 2010 12:48:31 -0400
Received: by qwk3 with SMTP id 3so451985qwk.19
        for <linux-ext4@vger.kernel.org>; Sat, 23 Oct 2010 09:48:30 -0700 (PDT)
In-Reply-To: <CB87EF37-0485-4A48-B401-EA594BE47B29@paradoxo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 19, 2010 at 5:23 PM, Felipe Franciosi <felipe@paradoxo.org> wrote:
> Dear all,
>
> I am experimenting on a 2.6.20.3-ubuntu1 kernel to prototype and evaluate
> different methods for migrating datablocks for a given inode on the fly.
>
> I have created an ioctl call that implements some verifications and invokes
> a function I wrote in balloc.c for such migration.
>
> Upon receiving a struct inode*, I retrieve the corresponding iloc using the
> ext3_get_inode_iloc() function and then the struct ext3_inode* using the
> ext3_raw_inode() on the iloc. I have confirmed the pointer is correct by
> printing several ext3_inode relevant fields.
>

you've complicated things too much.
all you have to do is modify EXT3_I(inode)->i_data and then call
ext3_mark_inode_dirty().
the rest of the iloc and raw inode stuff is taken care of by ext3_put_inode().

> After making my modifications to the i_block array, I am finding it
> impossible to commit these changes to the inode itself.
>

that is because your changes are being overriden by the unmodified ei->i_data.

> I have tried different things such as marking the iloc.bh buffer_head as
> dirty and submitting it for writing, marking the page as dirty, etc, but I
> think I'm missing something more fundamental. Most of my attempts were
> planned according to what I've seen inside similar code of buffer_head
> manipulation.
>

maybe you should have looked at code that modifies inodes instead...

> Can anyone shed some light on what I'm missing?
>

hope this helps,
Amir.
