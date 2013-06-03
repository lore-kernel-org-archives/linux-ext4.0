From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: How to differentiate ext4 from ext2/3 in code?
Date: Mon, 3 Jun 2013 13:16:49 -0400
Message-ID: <CADzUK1JrWM+Mm72wYAs_GL6s2A661X1q5VDmfopgZCGajXOshQ@mail.gmail.com>
References: <loom.20130531T090136-835@post.gmane.org>
	<20130531152845.GC19561@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58725 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab3FCRQv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jun 2013 13:16:51 -0400
Received: by mail-lb0-f172.google.com with SMTP id p10so4077694lbi.31
        for <linux-ext4@vger.kernel.org>; Mon, 03 Jun 2013 10:16:49 -0700 (PDT)
In-Reply-To: <20130531152845.GC19561@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was very very educational for a newbie like myself. Thanks

Autif

On Fri, May 31, 2013 at 11:28 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, May 31, 2013 at 07:04:18AM +0000, Felipe Monteiro de Carvalho wrote:
>> Hello,
>>
>> I am working on a software which has its own code to mount file systems, but
>> when working on adding ext4 support I just noticed something strange. The
>> ext2/3 reader already works quite well for ext4!
>>
>> Also: EXT2_SUPER_MAGIC == EXT3_SUPER_MAGIC == EXT4_SUPER_MAGIC
>>
>> So does anyone know what is the best way to differentiate in a file system
>> reader between ext3 and ext4?
>>
>> The best I came up so far would be checking the size of the superblock ... for
>> ext3 it seams to be smaller I think ... but I guess people here might have
>> better ideas.
>
> The right way to do this is to take a look at the file system features.  In the superblock:
>
>         __u32   s_feature_compat;       /* compatible feature set */
>         __u32   s_feature_incompat;     /* incompatible feature set */
>         __u32   s_feature_ro_compat;    /* readonly-compatible feature set */
>
> If your software doesn't understand a file system feature which is in
> the incompatible feature set, it must not try to do anything with the
> file system.
>
> If your software is only going to read from the file system (for
> example, in the case of a boot loader, or if the file system is going
> to be mounted read-only), then it can ignore the s_feature_ro_compat
> bitmask.  If your software is intending to modify the file system and
> there is a filesystem feature bit set that it doesn't know about, it
> MUST NOT try to modify the file system.
>
> It's important to check the file system feature bitmasks, since over
> time, we've added new features to ext2, ext3, and ext4.  It's more
> accurate to consider ext2, ext3, and ext4 to be different
> implementations of the same abstract file system, with the ext4 file
> system driver being the most fully featureful implementation.
>
> When people talk about a "ext4 file system", that's basically a
> shorthand for saying that it's an ext2/3/4 file system which has
> features enabled which the traditional ext2 and ext3 drivers in more
> recent kernels do not support.  But it's not a very precise statement.
> If someone asks me to debug "an ext4 file system", I will tell them
> that it's critically important that the send me the output of
> "dumpe2fs -h" so I can see what file system features were enabled for
> that particular file system.
>
> Similarly, when an enterprise distribution states that they support
> "ext4 file systems", there may be some newer ext4 file system features
> (such as bigalloc, inline_data, metadata_csum) which they do not
> support, even if the enterprise kernel supports said feature.
> Generally, in these cases the distribution will ship an
> /etc/mke2fs.conf file that only enables the file system features that
> they support when the user runs the "mke2fs -t ext4" command.
>
> I hope this helps,
>
>                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
