From: Steven Liu <lingjiujianke@gmail.com>
Subject: Re: [PATCH] ext4: fix the code style from printk to ext_debug in extents.c
Date: Sun, 13 May 2012 22:38:23 +0800
Message-ID: <CADxeRwnr-q433_nEqj9UCse57c=aJVwPWfBmkqVgWmM7BNhdDw@mail.gmail.com>
References: <CADxeRwnv7quZbWn9xZ=KnEg_KyT65DApEt57zDdgeYsRgQKYQw@mail.gmail.com>
	<20120513042006.GA31866@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34097 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2EMOiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 May 2012 10:38:25 -0400
Received: by bkcji2 with SMTP id ji2so3195125bkc.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 May 2012 07:38:23 -0700 (PDT)
In-Reply-To: <20120513042006.GA31866@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi ,
  You mean ,if open the CHECK_BINSEARCH, it must output the message
which I have changed code?

Thanks

2012/5/13 Ted Ts'o <tytso@mit.edu>:
> On Sat, May 12, 2012 at 11:57:13PM +0800, Steven Liu wrote:
>> Hi Ted,
>>
>> just fix the printk debug to ext_debug, if undefined the EXT_DEBUG
>> it will not output the debug message
>>
>> Signed-off-by: LiuQi <liuqi@zecloud.cn>
>
> I'm not sure what's the point? =A0The code in question is all under a
> CHECK_BINSEARCH, which is in itself a debugging option.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
