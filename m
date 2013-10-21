From: jon ernst <jonernst07@gmail.com>
Subject: Re: fix the ext4_read_inline_dir return value
Date: Mon, 21 Oct 2013 13:35:58 -0400
Message-ID: <CAGW2f1EdwAJTkqDPrRdfqGArw6nWp9bTZpnQWF5pwPP98omFkA@mail.gmail.com>
References: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Boxi Liu <boxi10liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:52269 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3JURf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2013 13:35:59 -0400
Received: by mail-qc0-f176.google.com with SMTP id s19so3224761qcw.21
        for <linux-ext4@vger.kernel.org>; Mon, 21 Oct 2013 10:35:58 -0700 (PDT)
In-Reply-To: <CAAFszuV7tXpGA5GVWtLzzHZayPgN-M+n_W4LN67i=ueicfZb+Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

what's ur point adding "ret =3D 0;" after "goto out;"
maybe before "goto"?

Best,


On Mon, Oct 21, 2013 at 12:33 PM, Boxi Liu <boxi10liu@gmail.com> wrote:
> hi=EF=BC=8C
> there may be a bug in ext4_read_inline_dir() function with inline_dat=
a feature.
> when I recursion call a sys_old_readdir to read a direntry's
> sub_dentry,I find that the ext4_read_inline_dir return the len of the
> inline_data ,but in the no inline_data case,it will return 0.It is
> inconsistent.
> So I try to make a patch to fix it.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
