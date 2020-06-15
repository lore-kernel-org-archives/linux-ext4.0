Return-Path: <SRS0=jTk8=74=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB504C433E0
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Jun 2020 17:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D677206D7
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Jun 2020 17:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bz/5CzX4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgFORx2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Jun 2020 13:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgFORx0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jun 2020 13:53:26 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6F0C061A0E
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2020 10:53:25 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id r11so9877389vsj.5
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2020 10:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8f0ns2WRMhSdhFZFC5v1bVPI2p8t4C+HdR2wAJJJLso=;
        b=bz/5CzX4tYq3Pb8GlGO2WqStOndrZ72+StAhLkMJitnwUseoj01bZ8ttbjJnG5QRf6
         L/+56gshBnZnMuu3VaabYFG0eF0q9oRwCruPVph4rk+0YWl/NUPV3MbBi7uGE55eSnvi
         CO7P5CqM0SkJRePlYms0nmkfLPYv143WvLP+6IAbkRYOUf8boVgrAQ2wusogsbG3LJdW
         yVm+RAb5CDER76Is7Vmwmj0z2WluAbkvkyYX6+eP6Nws9JGStv5k75mgPw1ZHHW5ueAs
         9NX8DlQ4jj8Vh+ssQrZKQyHqS5bnFS9j5ZyRP4DFgcVcuXL6s4bp57cnBE1lM8SuDQMv
         nAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=8f0ns2WRMhSdhFZFC5v1bVPI2p8t4C+HdR2wAJJJLso=;
        b=pjQOkkxPj3VHp0xWcUHcX5i1UvduLBFPjkinhs81hZrOlyEZgapqxldF1it1JPnpcR
         dftodGURS0sUCBZ0GTgk/VVS+Xv4ckOfQYv6OujeYPsr+bHjGMyH8+96jHkvkcga6agL
         HXNwtPqeeud54/afE10Ymg9uAR2iXgSul6RgSQaQyjnKFdSDoWc8YUHiea9gDOVPFjFT
         1puCw402VD1jkQq2E3DK2wIgl9Ryo4rnukZNwOrZAl/ZaEzIX6nJFFM8RyXbn8ZZzRBV
         902/biNr13nQwp0RggLRyBkbtyaDNhCyYfH5yryc1BXnDKaJoQlLLGdzNfrHWi1sMcbq
         PKaw==
X-Gm-Message-State: AOAM530HcCkZkd+ywDo/2YgXApSs1C9Mk0BVlhcicyEcTG3mgrBHklU8
        lYPvyAvGaPO8KYv7KFyv+EZMSX9uX4dRMWRJBEdfAV52
X-Google-Smtp-Source: ABdhPJxygsEiIJS5GgzUSPvfgkgqkdpxWIQCVCRdB53yycr+vLpoJl24MH+mBiDvvck3dlQuvYI/Uz+qcc3pv3MaQ0c=
X-Received: by 2002:a67:1e45:: with SMTP id e66mr14249333vse.95.1592243602886;
 Mon, 15 Jun 2020 10:53:22 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 15 Jun 2020 18:53:11 +0100
Message-ID: <CAL3q7H4boq-Rsm+OSK5bSBJhu-ywugOdwWfHRQkyuyDC_RoRZA@mail.gmail.com>
Subject: RWF_NOWAIT writes not failing when writing to a range with holes
To:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

I found out a bug in btrfs where a RWF_NOWRITE does not fail if we
write to a range that starts with an extent followed by holes (since
it requires allocating extent(s)).

When writing a test case for fstests I noticed xfs fails with -EAGAIN
as expected, but ext4 succeeds just like btrfs currently does:

mkfs.ext4 -F /dev/sdb
mount /dev/sdb /mnt

xfs_io -f -d -c "pwrite -S 0xab -b 256K 0 256K" /mnt/bar
xfs_io -c "fpunch 64K 64K" /mnt/bar
sync
xfs_io -d -c "pwrite -N -V 1 -b 128K -S 0xfe 0 128K" /mnt/bar

Is this a known bug? Or is there a technical reason that makes it too
expensive to check no extents will need to be allocated?

Thanks.

--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
