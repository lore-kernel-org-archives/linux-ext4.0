From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h
 in super.c
Date: Tue, 20 Nov 2012 00:23:56 +0800
Message-ID: <20121119162356.GB2337@gmail.com>
References: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
 <20121119133944.GA11095@gmail.com>
 <CAK9yfHyLzJE+rH3L0UN1x2dVNcEdaR=F7Z_Q2NfTidV2GKuP=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, patches@linaro.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2KSQLW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 11:11:22 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3564067pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 08:11:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAK9yfHyLzJE+rH3L0UN1x2dVNcEdaR=F7Z_Q2NfTidV2GKuP=g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 08:36:06PM +0530, Sachin Kamat wrote:
> Hi Zheng,
> 
> On 19 November 2012 19:09, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > On Mon, Nov 19, 2012 at 04:47:22PM +0530, Sachin Kamat wrote:
> >> ext4_extents.h was included twice.
> >>
> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> >> ---
> >>  fs/ext4/super.c |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> index ad6cd8a..c8a6138 100644
> >> --- a/fs/ext4/super.c
> >> +++ b/fs/ext4/super.c
> >> @@ -50,7 +50,6 @@
> >>  #include "xattr.h"
> >>  #include "acl.h"
> >>  #include "mballoc.h"
> >> -#include "ext4_extents.h"
> >
> > Hi Sachin,
> >
> > Sorry, I don't find this duplicated code in mainline kernel 3.7-rc6.
> 
> The duplicated code is available on the linux-next tree (20121115).
> The second instance was added by the commit
> "ext4: let ext4 maintain extent status tree" (commit id: 51865fda).

Good catch.  Sorry for my fault that introduces this duplicated code.
The patch looks good to me.

Regards,
                                                - Zheng
