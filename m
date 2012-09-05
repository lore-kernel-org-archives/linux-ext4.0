From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file systems
Date: Wed, 5 Sep 2012 13:16:35 +0800
Message-ID: <CAGBYx2YgL6h2-EfHKrWe7dMXjS2u7a=F39gCL3VeCjJKFDYq7A@mail.gmail.com>
References: <20120903164525.GD5066@thunk.org> <1346690758-21072-1-git-send-email-tytso@mit.edu>
 <1346690758-21072-2-git-send-email-tytso@mit.edu> <CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
 <20120904021412.GG5066@thunk.org> <504634D6.20608@iki.fi> <CAGBYx2ZRUdY1CFVnpqB-3LOr5Gs5Cs7UBv2SDxXW9Xqps_m6vQ@mail.gmail.com>
 <20120905045548.GA29950@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
	Kevin Liao <kevinlia@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53211 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab2IEFQ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Sep 2012 01:16:57 -0400
Received: by lagy9 with SMTP id y9so61144lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 22:16:56 -0700 (PDT)
In-Reply-To: <20120905045548.GA29950@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Got it!

Thanks,
Yongqiang.

On Wed, Sep 5, 2012 at 12:55 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Sep 05, 2012 at 10:10:29AM +0800, Yongqiang Yang wrote:
>> Hi Anssi,
>>
>> The bug was fixed for a while, please check the patches:
>> [PATCH 1/2] ext4: teach resize report old blocks count correctly
>> [PATCH 2/2] ext4: ignore last group without enough space when resizing
>>
>> Please have a try!!!
>
> Yongqiang,
>
> In the future, if a patch is going to fix a BUG_ON or kernel crash,
> please state so explicitly in the commit description along with
> instructions about how to reproduce the problem.  The urgency of a
> patch which (for example) fixes a debugging printk (such as your 1/2
> patch above) is quite different from a patch which causes a kernel
> BUG_ON.
>
> One of the reasons why I hadn't gotten around to processing your
> patches until now was partially because I knew there was a lot of
> testing and fixing before the patches were fully baked (as soon as I
> started doing testing I found all sorts of other problems, which I had
> to fix), but also because the commit descriptions were not clear
> enough.
>
> Patches where it's obvious what they fix, and where there is a clear
> explanation about what they fix and the priority of their fix makes
> life easier for me, and makes it more likely that I can process the
> patches quickly.
>
> Also, if you have a follow-on set of patches which is dependent on the
> initila set of patches, it's very helpful to resend a v2 version of
> the patches so that it's clear how the patches fit together.
>
> I'll take care of these two extra patches, and then you'll see me send
> out a -v2 set of the patches which contain all of the online resize
> patches rebased to the latest kernel and tested as much as possible.
> In general, though, in order for me to scale, I really need ext4
> developers to do as much of this testing, rebasing, and reposting
> patches as possible, and for other ext4 developers to review the
> patches.  If I have to do all of this myself, patches will flow into
> mainline more slowly, and we'll start accumulating a much longer
> backlog.
>
> Regards,
>
>                                                 - Ted



-- 
Best Wishes
Yongqiang Yang
