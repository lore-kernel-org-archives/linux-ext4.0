Return-Path: <SRS0=sRFN=33=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFFCC35242
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Feb 2020 15:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562AD214AF
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Feb 2020 15:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGPi3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 Feb 2020 10:38:29 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59130 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726982AbgBGPi3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Feb 2020 10:38:29 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-101.corp.google.com [104.133.0.101] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 017FcOAI024382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Feb 2020 10:38:25 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 48821420324; Fri,  7 Feb 2020 10:38:24 -0500 (EST)
Date:   Fri, 7 Feb 2020 10:38:24 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-ext4@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: ext4 dio RWF_NOWAIT change
Message-ID: <20200207153824.GA122530@mit.edu>
References: <20200205091344.u5c3nnblezzh5xgb@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205091344.u5c3nnblezzh5xgb@xzhoux.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 05, 2020 at 05:13:44PM +0800, Murphy Zhou wrote:
> Hi,
> 
> Kernel commit 378f32bab3714f04c4e0c3aee4129f6703805550
> Author: Matthew Bobrowski <mbobrowski@mbobrowski.org>
> Date:   Tue Nov 5 23:02:39 2019 +1100
> 
>     ext4: introduce direct I/O write using iomap infrastructure
> 
> 
> Changed the logic of dio+RWF_NOWAIT
> 
> from:
> 
> -       if (!inode_trylock(inode)) {
> -               if (iocb->ki_flags & IOCB_NOWAIT)
> -                       return -EAGAIN;
> -               inode_lock(inode);
> -       }
> 
> 
> to:
> 
> +       if (iocb->ki_flags & IOCB_NOWAIT) {
> +               if (!inode_trylock(inode))
> +                       return -EAGAIN;
> +       } else {
> +               inode_lock(inode);
> +       }
> 
> 
> fstests generic/471 expecet EAGAIN on this situation, so it started to
> fail since than.

I don't understand why this specific change would cause the situation.
In the generic/471 test, here iocb->ki_flags will have IOCB_NOWAIT
set, and in that case I don't see how there would be a change in
behavior with respect to EAGAIN being returned.

In any case, I've been suppressing generic/471 because of concerns
that the test is bogus so I hadn't noticed.  From
kvm-xfstests/test-appliance/files/root/fs/global_exclude:

# The test generic/471 tests the RWF_NOWAIT flag; however
# how it is supposed to work with file systems is disputed,
# and not all device drivers support it.  As a result
# it doesn't work if an LVM device driver is in use (as is the
# case with gce-xfstests).  So let's suppress it for now.  For
# more details see:
# https://lore.kernel.org/linux-block/20190723220502.GX7777@dread.disaster.area/
generic/471

							- Ted
