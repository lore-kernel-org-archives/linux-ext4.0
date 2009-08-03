From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 1/2] ext4: fix journal ref count in move_extent_par_page
Date: Mon, 3 Aug 2009 21:17:10 +0800
Message-ID: <6149e97b0908030617q2dfe598bsbbac45969f1f2625@mail.gmail.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com>
	 <4A76A00F.30506@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46913 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbZHCNRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 09:17:11 -0400
Received: by gxk9 with SMTP id 9so5777991gxk.13
        for <linux-ext4@vger.kernel.org>; Mon, 03 Aug 2009 06:17:11 -0700 (PDT)
In-Reply-To: <4A76A00F.30506@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Akira,

2009/8/3 Akira Fujita <a-fujita@rs.jp.nec.com>:
> Hi Peng,
>
> Peng Tao wrote:
>> move_extent_par_page calls a_ops->write_begin() to increase journal =
handler's
>> reference count. However, if either mext_replace_branches() or ext4_=
get_block
>> fails, the increased reference count isn't decreased. This will caus=
e later
>> umounting of the fs forever hangs. The patch addresses the issue by =
calling
>> ext4_journal_stop() if page is not NULL (which means a_ops->write_en=
d() isn't
>> invoked).
>
> In case mext_replaced_branches() or ext4_get_block failed,
> ext4_journal_stop() is called at out2 label(*)
> and then journal reference counter is decreased.
> Therefore I think this fix is not necessary.
well, the orginal code calls both ext4_journal_start and
a_ops->write_begin(). So the journal reference was increased twice but
only gets decreased once in case of failure. This can be simply
verified by returning -1 at the begining of mext_replaced_branches().
With such modification, the fs cannot be umounted because of the wrong
reference count.
>
> static int
> move_extent_par_page(struct file *o_filp, struct inode *donor_inode,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pgoff_t=
 orig_page_offset, int data_offset_in_page,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int blo=
ck_len_in_page, int uninit)
> <snip>
>
> out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(page)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (PageLocked=
(page))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0unlock_page(page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0page_cache_rel=
ease(page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> out2:
> * =C2=A0 =C2=A0 =C2=A0 ext4_journal_stop(handle);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret < 0 ? ret : 0;
> }
>
> Regards,
> Akira Fujita
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
