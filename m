From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: e4defrag and immutable files
Date: Fri, 28 May 2010 17:21:34 -0400
Message-ID: <AANLkTikM11wkmzq7NtAOyz0fz88oe1bp9T2VQw0sK_Y8@mail.gmail.com>
References: <4C002427.3010706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:62828 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0E1VVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 17:21:36 -0400
Received: by ywh36 with SMTP id 36so1087473ywh.4
        for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 14:21:35 -0700 (PDT)
In-Reply-To: <4C002427.3010706@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 28, 2010 at 4:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Hi all,
>
> I have looked a bit at e4defrag, and it does not appear to prevent th=
e
> relocation of files marked immutable. =A0This is a problem for boot
> loaders, which may need to have a block pointer to a specific file in
> order to bootstrap themselves.
>
> Would it be possible to either:
>
> a) prevent e4defrag and/or EXT4_IOC_MOVE_EXT from relocating an
> immutable file, or
> b) add a new attribute with the above property (in case there is
> legitimate need to move around immutable files)?
>
> =A0 =A0 =A0 =A0-hpa


Other projects / tools than e4defrag use EXT4_IOC_MOVE_EXT, so it
would be best to do this in the kernel in my opinion.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
