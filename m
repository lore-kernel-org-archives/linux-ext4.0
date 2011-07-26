From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Checks in ext4_ext_fiemap_cb() broken
Date: Tue, 26 Jul 2011 09:20:28 +0800
Message-ID: <CAGBYx2ZsxvmEcC0akMRQTgDWUmkUHOp=D4Ff69_pSMb+bGH5Sg@mail.gmail.com>
References: <20110725155836.GF6107@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41838 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1GZBU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 21:20:28 -0400
Received: by pzk37 with SMTP id 37so9425339pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 18:20:28 -0700 (PDT)
In-Reply-To: <20110725155836.GF6107@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

I have been thinking if we can handle fiemap much simpler for a while.
 Current code is very ugly due to page cache look up.  I have a
thought on simplifying these code.  The reason leading us to looking
up page cache is that delayed extents are not in extents tree.  I
think we can add an in-memory delayed extents list in inode, and we
can delete entries in the list after we allocate blocks for them.
There is no limit on length of extents in the list, this way can an
entry contain as many blocks as they are contiguous logically.

What's your opinion?

Yongqiang.

On Mon, Jul 25, 2011 at 11:58 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hello,
>
> =A0I just had a look at the code checking delayed allocated buffers i=
n
> ext4_ext_fiemap_cb(). I believe the checks there could use some elimi=
ation
> of common patterns but that's just a minor thing. The main problem is=
 that
> the code can easily crash the kernel when it races with page reclaim.=
 You
> just cannot access most of the page contents (and for buffers it is
> especially true) without locking the page. Getting a reference via
> find_get_pages_tag() guarantees you the structure cannot go away but =
mm is
> still free to detach the page from the mapping at any moment. So you =
must
> always lock a page and check that it still belongs to the desired map=
ping
> before you check 'page_has_buffers()'.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
