From: shenghui <crosslonelyover@gmail.com>
Subject: Re: [PATCH] ext2: return -ENODATA for NULL i_file_acl in
	ext2_xattr_list
Date: Wed, 14 Jul 2010 07:47:36 +0800
Message-ID: <AANLkTinbNujdr6qM7kMyOLFMqjRibwvLZIfMB6J3MzX3@mail.gmail.com>
References: <4C3C7E59.8040905@gmail.com>
	<7D4617C2-565E-4F34-94B4-3F308EB75D18@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59738 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0GMXrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jul 2010 19:47:37 -0400
In-Reply-To: <7D4617C2-565E-4F34-94B4-3F308EB75D18@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/7/14 Andreas Dilger <adilger@dilger.ca>:
> The "error" value gets overwritten almost immediately with -EIO, and =
then at the end of the function if there is an xattr block but it doesn=
't contain any attributes (I'm not sure if this could happen, but it se=
ems possible) it will return "error =3D buffer_size - rest; =C2=A0/* to=
tal size */", so 0 if "rest" was not changed from its initial value of =
buffer_size.
>
> The question is why this return value should be changed to -ENODATA i=
n the first place? =C2=A0This isn't true for ext3_xattr_list() or ext4_=
xattr_list(). =C2=A0I tend to think it is not an error to get back an e=
mpty list, and applications shouldn't treat it as such. =C2=A0Most appl=
ications will check "if (rc < 0)" and treat it as an error. =C2=A0This =
is different than e.g. requesting a specific value by name (which does =
return -ENODATA) because it would otherwise be ambiguous whether the xa=
ttr existed but had zero size or didn't exist at all.
>

Thanks for your explanation!

--=20


Thanks and Best Regards,
shenghui
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
