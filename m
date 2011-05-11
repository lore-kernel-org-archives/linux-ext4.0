From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: ext4_ext_convert_to_initialized bug found in extended FSX testing
Date: Wed, 11 May 2011 09:47:23 +0800
Message-ID: <BANLkTi=jjVcy9WQvNfYwPVNw-+t4M5WbFw@mail.gmail.com>
References: <4DC97C32.2020203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54703 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1EKBrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 21:47:24 -0400
Received: by vws1 with SMTP id 1so31573vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 18:47:23 -0700 (PDT)
In-Reply-To: <4DC97C32.2020203@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 11, 2011 at 1:56 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi All,
>
> We've been trying to get punch hole through some extended fsx tests, =
and I ran across some other tests that were failing because the test fi=
le contained zeros where it shouldn't. =A0I made this fix to the ext4_e=
xt_convert_to_initialized

What do you mean zeros here?
Some useful data is zeroed?

and the test has been running smooth for about an hour now.
Yongqiang, this one looks like it may have been associated with the
split extents clean up patch. =A0Would you mind taking a look at this
fix and giving it your ok if it looks good? =A0Thx!
>
> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 e363f21... ce69450... M =A0fs/ext4/extents.c
> =A0fs/ext4/extents.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index e363f21..ce69450 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2819,7 +2819,8 @@ static int ext4_ext_convert_to_initialized(hand=
le_t *handle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* case 3 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0zero_ex.ee_block =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cpu_to_le32(map->m_lblk + map->m_len);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_=
to_le16(allocated - map->m_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zero_ex.ee_len =3D cpu_=
to_le16(ee_len -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 allocated - map->m_len);
The logic is that we splits [ee_block, ee_block + ee_len) into
[ee_block, map->m_blk) that is uninitialized and [map->m_blk, ee_block
+ ee_len) that is initialized.   We need to zero [map->m_lblk +
map->m_len, ee_block + ee_len).
and [map->m_lblk, map->m_lblk + map->m_len) is zeroed by upper layer
because of MAP_NEW flag.

Right logic?


I can not see the error and the meaning of ee_len - allocated - map->m_=
len.

Thanks,
Yongqiang.


> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_ext_store_pblock(=
&zero_ex,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_e=
xt_pblock(ex) + map->m_lblk - ee_block);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ext4_ext_zeroo=
ut(inode, &zero_ex);
> --
> 1.7.1
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
