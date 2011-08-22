From: Aditya Kali <adityakali@google.com>
Subject: Re: attempt to fix race in bigalloc code path
Date: Mon, 22 Aug 2011 10:30:02 -0700
Message-ID: <CAGr1F2EG32dkeo+6DU4caQdJtFBLN7kpF9a4Gj_vr+awdGZ6jw@mail.gmail.com>
References: <CAGBYx2ZTzrLR2yRRnCu3pvFWvofYzJp7+WsdQt2=Y7yWGEzyTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f70.google.com ([209.85.210.70]:54065 "EHLO
	mail-pz0-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1HVRaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Aug 2011 13:30:23 -0400
Received: by pzk37 with SMTP id 37so6209pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 10:30:23 -0700 (PDT)
In-Reply-To: <CAGBYx2ZTzrLR2yRRnCu3pvFWvofYzJp7+WsdQt2=Y7yWGEzyTg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 22, 2011 at 6:54 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Hi,
>
> I can not find the patch - attempt to fix race in bigalloc code path =
-
> in the mailing list.
>
> I don't think this patch can work. =C2=A0set_buffers_da_mapped() is c=
alled
> under i_data_sem, so it can not lock page. =C2=A0If the page is not l=
ocked,
> calling page_has_buffers() is not secure as Jan pointed out
> previously. =C2=A0If a page is partially mapped(block size < page siz=
e),
> setting BH_Da_Mapped without locking page is not safe too.
>
The BH_Da_Mapped is set only during page writeback when the page is
locked (in write_cache_pages_da). So, the setting of BH_Da_Mapped
should be safe, no ?

> BTW: =C2=A0find_delalloc_range() does not lock page as ext4_fiemap_cb=
().
> As Jan said, it can crash system. =C2=A0BUT we can not lock page in b=
oth
> scenarios, because i_data_sem is hold. So delayed extent list is
> necessary. =C2=A0I have finished the code implementing delayed extent=
 list,
> which needs some further testing.
>
>
> What are your opinions?
>
I agree that having a delayed extent list will greatly simply this
solution in this case.

>
> --
> Best Wishes
> Yongqiang Yang
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
