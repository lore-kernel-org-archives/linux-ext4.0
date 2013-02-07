From: shilong wang <wangshilong1991@gmail.com>
Subject: Re: [PATCH 1/3] Ext2: remove the overhead check about sb in the
 function ext2_new_blocks
Date: Thu, 7 Feb 2013 23:22:21 +0800
Message-ID: <CAP9B-Qk-BQL9goEGfxhHPBAG45Va1joRNP0QBJ5C_AEXhvof=A@mail.gmail.com>
References: <5112BB97.8040206@gmail.com>
	<20130206065645.GA32665@gmail.com>
	<20130206182931.GB1410@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	gnehzuil.liu@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46546 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab3BGPWW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 10:22:22 -0500
Received: by mail-ie0-f172.google.com with SMTP id c10so3658825ieb.31
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 07:22:21 -0800 (PST)
In-Reply-To: <20130206182931.GB1410@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2013/2/7 Theodore Ts'o <tytso@mit.edu>:
> On Wed, Feb 06, 2013 at 02:56:46PM +0800, Zheng Liu wrote:
>>
>> If you want to re-send a patch series, add [RESEND] in subject, please.
>> Because it could make us know which is the latest one. :-)
>
> Ideally, use RESEND if you haven't changed the patch series since the
> last time you've sent it.  If you have changed it, please use [PATCH
> v2], [PATCH v3], etc.

I get it..
Thanks, thanks every one  for teaching me so much...

Now i am trying to do something for ext4 development in my leisure time..
Since i don't know anything about filesystem before.. i have to study
about it from minix to ext2..ext3..ext4..btrfs..

However, it still seems a little hard for me to figure everything out
just by reading code... So i wonder where i can get
some papers or articles about the new concept of filesystems.. for
example extent management or something else for ext4..etc
Maybe it helps a lot for me...

Thanks,
Wang

>
> Thanks,
>
>                                                 - Ted
