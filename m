From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Factor common code from convert and split-unwritten.
Date: Tue, 3 May 2011 10:35:42 +0800
Message-ID: <BANLkTi=R+3NhsykOhHrmhVEOsuS5uf4BoQ@mail.gmail.com>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	cmm@us.ibm.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1ECCfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 22:35:43 -0400
Received: by vws1 with SMTP id 1so4701493vws.19
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2011 19:35:42 -0700 (PDT)
In-Reply-To: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

The patch series has been tested by Allison with punch hole patch serie=
s.

Yongqiang.

On Tue, May 3, 2011 at 10:04 AM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> v1->v2:
> =A0 Remove optimization in v1.
>
> v0->v1:
> =A0 Fix a bug in ext4_ext_convert_to_initialized() reported by
> =A0 Allison Henderson <achender@linux.vnet.ibm.com>
>
> =A0 optimize ext4_ext_convert_to_initialized().
>
> The patch series factor common code from ext4_ext_convert_to_initiali=
zed()
> and ext4_split_unwritten_extents() so that extent-move-on-write in sn=
apshot
> and punch-hole can be built on the common code.
>
> [PATCH v2 1/3] ext4:Add a function merging extent right and left.
> [PATCH v2 2/3] ext4:Add two functions splitting an extent.
> [PATCH v2 3/3] ext4:Reimplement convert and split_unwritten.
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
