Return-Path: <SRS0=u157=R5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA2DCC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Mar 2019 12:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 839BA2075C
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Mar 2019 12:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfCZMVd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:21:33 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39280 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfCZMVd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2019 08:21:33 -0400
Received: by mail-ua1-f68.google.com with SMTP id m11so4195245uad.6;
        Tue, 26 Mar 2019 05:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0LHglQT1f437mmg50cwuiu0jSI/QSmreDNK8X0LzGX8=;
        b=J/DD4d/kEMxi3QxAW7wXEI6219JMul5vxrVk4MxYnCBHe4nikBLNKQe/Vv0BovuVjv
         TlMPiPCorNgpaqnvSDO2c5SxnFuWw5NRjTwVKdOWBrYoyJwDCDB/MfZJWy7VHtt48cQi
         Yci7aqmy/3jj3AkQOwSqZIbjH50ODcTK4H6jIOdEanU7DM/suTIEWOcUVq9Ht+/S9GU2
         Vv8h7RbYQpntXXcpXmXyMo8kAK6heyb1FGYubNVVMJ+EVs0G1IW3RDlActn3tcj3Y8OC
         Xoa1J7Rw3c2EIrwXUSkGPPus3fuyvPNxnIzWve1KEdx/tiW564GFSF24QQzTpykqpDxr
         cRIw==
X-Gm-Message-State: APjAAAWZzSvA/24yihtAhsEHdaeuQcNYSqttHLv8hiKhmNZlT/jqc7dK
        p4P30ivLrAuS2/vXkDdjjllf1zAc8FfqKoW/yD4=
X-Google-Smtp-Source: APXvYqwMAeQCE5FD5PLOulzOKD30uF1hL+bCbiskugIsWJKsz+sxYE0beCVz8/EvC/71tUV3KJ6H0cAU9NuudNolqhs=
X-Received: by 2002:ab0:6819:: with SMTP id z25mr4886006uar.0.1553602891732;
 Tue, 26 Mar 2019 05:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190323003532.GB1180@magnolia>
In-Reply-To: <20190323003532.GB1180@magnolia>
From:   Filipe David Manana <fdmanana@apache.org>
Date:   Tue, 26 Mar 2019 12:21:20 +0000
Message-ID: <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
Subject: Re: [PATCH] generic: prohibit fstrim on journalled filesystems with norecovery
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 23, 2019 at 12:35 AM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> This test makes sure that we can't use stale unrecovered fs metadata to
> drive a DISCARD festival on a disk and thereby destroy user data by
> accident.

It would help to have listed the name of the patches that fix the
issues on xfs/ext4/btrfs, to make it faster.

>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks for doing this. Just one question below.

> ---
>  tests/generic/714     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/714.out |    4 +++
>  tests/generic/group   |    1 +
>  3 files changed, 66 insertions(+)
>  create mode 100755 tests/generic/714
>  create mode 100644 tests/generic/714.out
>
> diff --git a/tests/generic/714 b/tests/generic/714
> new file mode 100755
> index 00000000..1849a5e9
> --- /dev/null
> +++ b/tests/generic/714
> @@ -0,0 +1,61 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 714
> +#
> +# Ensure that we can't call fstrim on filesystems mounted norecovery, because
> +# FSTRIM implementations use free space metadata to drive the discard requests
> +# and we told the filesystem not to make sure the metadata are up to date.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_os Linux
> +_require_scratch
> +_require_fstrim
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_require_metadata_journaling $SCRATCH_DEV
> +
> +echo "fstrim on regular mount"
> +_scratch_mount >> $seqres.full 2>&1
> +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 || \
> +       _notrun "FSTRIM not supported"
> +_scratch_unmount
> +
> +echo "fstrim on ro mount"
> +_scratch_mount -o ro >> $seqres.full 2>&1
> +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
> +_scratch_unmount
> +
> +echo "fstrim on ro mount with no log replay"
> +norecovery="norecovery"
> +test $FSTYP = "btrfs" && norecovery=nologreplay
> +_scratch_mount -o ro,$norecovery >> $seqres.full 2>&1
> +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 && \
> +       echo "fstrim with unrecovered metadata just ate your filesystem"
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/714.out b/tests/generic/714.out
> new file mode 100644
> index 00000000..1158a2ff
> --- /dev/null
> +++ b/tests/generic/714.out
> @@ -0,0 +1,4 @@
> +QA output created by 714
> +fstrim on regular mount
> +fstrim on ro mount
> +fstrim on ro mount with no log replay
> diff --git a/tests/generic/group b/tests/generic/group
> index 2e4341fb..c2046293 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -538,6 +538,7 @@
>  533 auto quick attr
>  534 auto quick log
>  535 auto quick log
> +714 auto trim

Any reason to not add the 'quick' group as well? It runs in 1 second
for me on btrfs, xfs and ext4 with a debug kernel.

>  940 auto quick clone punch
>  941 auto quick clone punch
>  942 auto quick clone punch



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
