Return-Path: <SRS0=Oy82=PD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr780094.outbound.protection.outlook.com ([40.107.78.94]:10752
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbeLZEH1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Dec 2018 23:07:27 -0500
Date: Tue, 25 Dec 2018 23:07:13 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Liu Bo <obuil.liubo@gmail.com>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        <stable@kernel.org>
Subject: Re: [PATCH] ext4: make sure enough credits are reserved for
 dioread_nolock writes
Message-ID: <20181226040713.GA4158@mit.edu>
References: <20181225053326.7012-1-tytso@mit.edu>
 <CANQeFDAL=Bx6dq69Rzmz_OWXkXMz=KzLvEkw4rQSSqMW9OHWMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANQeFDAL=Bx6dq69Rzmz_OWXkXMz=KzLvEkw4rQSSqMW9OHWMQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 25, 2018 at 04:10:25PM -0800, Liu Bo wrote:
> 
> I had a patch[1] to address the problem but with adding reservation
> only when we need to (in ext4_ext_try_to_merge_up).

Sorry, I had forgotten that you had that patch pending.  I believe
that merging up isn't the only case we need to worry about, though.
For example, if we write into the middle of a larger unwritten region,
we might havec to change a single region into three regions, which
might require a node split --- and in that case, it's not optional, as
would be in the try_to_merge_up situation.  If we don't have enough
credits to do a node split our only choices would be mark the file
system as corrupted, or to fail the write with ENOSPC (which would be
very confusing to the user/application).

Cheers,

					- Ted
