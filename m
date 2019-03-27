Return-Path: <SRS0=Z8NG=R6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A45C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 03:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C680A206B8
	for <linux-ext4@archiver.kernel.org>; Wed, 27 Mar 2019 03:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="exOvx0fp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbfC0D0x (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Mar 2019 23:26:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49152 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfC0D0x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2019 23:26:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2R3J8XF115467;
        Wed, 27 Mar 2019 03:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=t/frDXNFhYVOWV5YwOaF5vJMLUC06r+5+Yv4hal8GnQ=;
 b=exOvx0fpxxcDtL7SxoSAN3bAzlP5bsQ9KChEawAplzbup+1dr1o64R60eltoGcFrp0m9
 /xnjWa3p5wkYAzJgaWwa3pPbfeEPMkSTipKrG5911/Q6oNNdCf9MQz31hJ2ctuuPnF7p
 w8g8OER2JzKRbDsFxLZ4ahCNNg+XtKTcB0vVrtXefzSiELkmjsXfwE7uaBU1KQolcrwT
 0k//qqjXkKSUlx9McPLkdRv9xAGI/Uzx0ZmbyrHKDRbH2uWkcQmzHyna5XCAUr02YCb4
 b5cps9NL3yhVMOJVhyYU2y4p9UeEykON+i7mt5FjXSiuxAlD1H5n9pB7kMHOWmKu0pOZ Uw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2re6dje31v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Mar 2019 03:26:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2R3Ql0N030815
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Mar 2019 03:26:47 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2R3QkKi019355;
        Wed, 27 Mar 2019 03:26:47 GMT
Received: from localhost (/10.159.151.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Mar 2019 20:26:46 -0700
Date:   Tue, 26 Mar 2019 20:26:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Filipe David Manana <fdmanana@apache.org>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] generic: prohibit fstrim on journalled filesystems with
 norecovery
Message-ID: <20190327032645.GB1183@magnolia>
References: <20190323003532.GB1180@magnolia>
 <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4Un5e5xOkTgAVXthfr-N1CXwf6e4qOyQ9WeXQoj3E8Uw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9207 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903270022
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 26, 2019 at 12:21:20PM +0000, Filipe David Manana wrote:
> On Sat, Mar 23, 2019 at 12:35 AM Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > This test makes sure that we can't use stale unrecovered fs metadata to
> > drive a DISCARD festival on a disk and thereby destroy user data by
> > accident.
> 
> It would help to have listed the name of the patches that fix the
> issues on xfs/ext4/btrfs, to make it faster.
> 
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Looks good, thanks for doing this. Just one question below.
> 
> > ---
> >  tests/generic/714     |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/714.out |    4 +++
> >  tests/generic/group   |    1 +
> >  3 files changed, 66 insertions(+)
> >  create mode 100755 tests/generic/714
> >  create mode 100644 tests/generic/714.out
> >
> > diff --git a/tests/generic/714 b/tests/generic/714
> > new file mode 100755
> > index 00000000..1849a5e9
> > --- /dev/null
> > +++ b/tests/generic/714
> > @@ -0,0 +1,61 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 714
> > +#
> > +# Ensure that we can't call fstrim on filesystems mounted norecovery, because
> > +# FSTRIM implementations use free space metadata to drive the discard requests
> > +# and we told the filesystem not to make sure the metadata are up to date.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_require_scratch
> > +_require_fstrim
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_require_metadata_journaling $SCRATCH_DEV
> > +
> > +echo "fstrim on regular mount"
> > +_scratch_mount >> $seqres.full 2>&1
> > +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 || \
> > +       _notrun "FSTRIM not supported"
> > +_scratch_unmount
> > +
> > +echo "fstrim on ro mount"
> > +_scratch_mount -o ro >> $seqres.full 2>&1
> > +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
> > +_scratch_unmount
> > +
> > +echo "fstrim on ro mount with no log replay"
> > +norecovery="norecovery"
> > +test $FSTYP = "btrfs" && norecovery=nologreplay
> > +_scratch_mount -o ro,$norecovery >> $seqres.full 2>&1
> > +$FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1 && \
> > +       echo "fstrim with unrecovered metadata just ate your filesystem"
> > +_scratch_unmount
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/714.out b/tests/generic/714.out
> > new file mode 100644
> > index 00000000..1158a2ff
> > --- /dev/null
> > +++ b/tests/generic/714.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 714
> > +fstrim on regular mount
> > +fstrim on ro mount
> > +fstrim on ro mount with no log replay
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 2e4341fb..c2046293 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -538,6 +538,7 @@
> >  533 auto quick attr
> >  534 auto quick log
> >  535 auto quick log
> > +714 auto trim
> 
> Any reason to not add the 'quick' group as well? It runs in 1 second
> for me on btrfs, xfs and ext4 with a debug kernel.

Probably just an oversight, I'll add it when I resubmit tomorrow.

Thanks for the review + btrfs fix. :)

--D

> >  940 auto quick clone punch
> >  941 auto quick clone punch
> >  942 auto quick clone punch
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
