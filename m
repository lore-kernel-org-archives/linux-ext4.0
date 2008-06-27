From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 27 Jun 2008 11:57:27 -0700
Message-ID: <20080627115727.149dcb2e.akpm@linux-foundation.org>
References: <20080624160056t-sato@mail.jp.nec.com>
	<20080624150925.765155f0.akpm@linux-foundation.org>
	<7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: "Takashi Sato" <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbYF0S5v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jun 2008 14:57:51 -0400
In-Reply-To: <7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 27 Jun 2008 20:33:58 +0900
"Takashi Sato" <t-sato@yk.jp.nec.com> wrote:

> >>  case XFS_FSOP_GOING_FLAGS_DEFAULT: {
> >> - struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
> >> + struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, 0);
> >
> > Using NULL here is clearer and will, I expect, avoid a sparse warning.
> 
> I checked it but I couldn't find a sparse warning in xfs_fsops.c.
> Can you tell me how to use NULL?

	struct super_block *sb = freeze_bdev(mp->m_super->s_bdev, NULL);

:)

It's much better to use NULL here rather than literal zero because the
reader of this code can then say "ah-hah, we're passing in a pointer". 
Whereas plain old "0" could be a pointer or a scalar.

We should always use NULL to represent a null pointer in the kernel. 
The one acceptable exception is when testing for nullness:

	if (ptr1)
		if (!ptr2)

Often people will use

	if (ptr1 != NULL)
		if (ptr2 == NULL)

in this case as well.  (I prefer the shorter version personally, but
either is OK).


