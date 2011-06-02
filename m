From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 1/2] ext4: arrange ext4_*_bit() macros
Date: Thu, 2 Jun 2011 19:04:40 +0900
Message-ID: <BANLkTi=mdiK7us_b-YKhiu60csQJTcihsw@mail.gmail.com>
References: <1306939009-11283-1-git-send-email-akinobu.mita@gmail.com>
	<46950A08-9300-4649-A38D-88829035DFC2@dilger.ca>
	<BANLkTikSKyKuseG+iehh=-wfDCu46sinZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38407 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1FBKEl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jun 2011 06:04:41 -0400
In-Reply-To: <BANLkTikSKyKuseG+iehh=-wfDCu46sinZw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/2 Amir Goldstein <amir73il@gmail.com>:
> FYI, one of the snapshot patches (snapshot_exclude_bitmap.patch)
> uses ext4_set_bit_atomic() to set bits in the exclude bitmap when
> moving blocks to snapshot file.
> Since moving blocks is not done in allocation context, there is no
> buddy/group lock held while manipulating the exclude bitmap.
> So I would appreciate if this specific macro will not be removed.
>
> Thanks, Yongqiang , for pointing that out.

OK, I'll keep ext4_*_bit_atomic() in the next version.
