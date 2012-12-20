From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole
 punch [V2]
Date: Thu, 20 Dec 2012 23:11:28 +0800
Message-ID: <CAJSVwFPWbipgN=GutTdy57dHDb+DjnDivwRwYY93LRB8cvCu3g@mail.gmail.com>
References: <CAJSVwFM3vq9wsq0Mn5L1bh-WHoP1g3VMJAOg_ruavZFednsjVw@mail.gmail.com>
	<20121220053914.GB22145@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f172.google.com ([209.85.210.172]:57525 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2LTPL2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Dec 2012 10:11:28 -0500
Received: by mail-ia0-f172.google.com with SMTP id z13so2982618iaz.31
        for <linux-ext4@vger.kernel.org>; Thu, 20 Dec 2012 07:11:28 -0800 (PST)
In-Reply-To: <20121220053914.GB22145@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/12/20 Theodore Ts'o <tytso@mit.edu>:
> On Thu, Dec 13, 2012 at 11:32:22PM +0800, Forrest Liu wrote:
>> When depth of extent tree is greater than 1, logical start value
>> of interior node didn't updated correctly in ext4_ext_rm_idx.
>>
>> Signed-off-by: Forrest Liu <forrestl@synology.com>
>
> Applied.
>
> BTW, your reproduction case also results in a file system which isn't
> noticed as being broken by e2fsck.  Eric's patch "e2fsck: Fix
> incorrect interior node logical start values" fixes e2fsck so it
> handles this.  Unfortunately applying his patch seems to uncover a bug
> in e2fsck when clearing a bad extent node (f_extent_bad_node) which we
> need to fix so the regression test suite is passing.
>
>                                             - Ted

Hi Ted,
   I will help to find out the problem in e2fsck.

Thanks,
Forrest
