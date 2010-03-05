From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: Re: [PATCH 11/28] ext4: correctly calculate number of blocks for
	fiemap
Date: Fri, 5 Mar 2010 17:46:58 +0100
Message-ID: <35b92b761003050846s55ac931dv93571c6b33c7b6f9@mail.gmail.com>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
	 <1267553925-6308-12-git-send-email-tytso@mit.edu>
	 <4B8E1410.1010107@rs.jp.nec.com> <20100303175217.GA3530@thunk.org>
	 <4B8F47C6.9060408@rs.jp.nec.com> <1267739098.4204.12.camel@michlmayr>
	 <4B90448A.2030609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:35452 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab0CEQrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Mar 2010 11:47:01 -0500
Received: by fxm19 with SMTP id 19so4327932fxm.21
        for <linux-ext4@vger.kernel.org>; Fri, 05 Mar 2010 08:47:00 -0800 (PST)
In-Reply-To: <4B90448A.2030609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/5 Eric Sandeen <sandeen@redhat.com>
>
> > Thank you for pointing this out. I had not checked s_maxbytes.
> > Appearently s_maxbytes can be 1<<(32 + s_blocksize_bits) - 1. There=
fore
> > the number of blocks in a file cannot be stored in a 32bit integer.
>
> For extent-based files it had better be....
>
> struct ext4_extent {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le32 =C2=A0ee_block; =C2=A0 =C2=A0 =C2=A0=
 /* first logical block extent covers */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__le16 =C2=A0ee_len; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* number of blocks covered by extent */
>
> The start block can't be more than 32 bits; this essentially limits
> the file size / maximum logical block to 2^32 blocks right?
>
> s_maxbytes comes out to 17592186044415
>
> 2^32 4k blocks is 17592186044416 bytes, or max byte offset 1759218604=
4415
>
> What am I missing? =C2=A0(confusion between max byte count and max
> byte offset, perhaps?)
>

Yes.=C2=A0The block offset has the maximum value 1<<32 - 1.
However the number of blocks may be 1<<32.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
