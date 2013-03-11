From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 0/5] ext4: try to fix up es regressions
Date: Mon, 11 Mar 2013 14:23:06 +0800
Message-ID: <20130311062306.GA3948@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <20130311021108.GD10090@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39211 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3CKGHy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 02:07:54 -0400
Received: by mail-pb0-f42.google.com with SMTP id xb4so3330504pbc.29
        for <linux-ext4@vger.kernel.org>; Sun, 10 Mar 2013 23:07:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130311021108.GD10090@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 10, 2013 at 10:11:08PM -0400, Theodore Ts'o wrote:
> I've placed these patches (with a few minor fixups) on the dev branch,
> and will start running a test/verification run on them).  Thanks for
> working on these patches!

Thanks.

As Dmitry's comment, I have updated my patches.

In patch 2 (ext4: add self-testing infrastructure to do a sanity check)
Dmitry suggests that we'd better replace 'retval != map->m_len' condition
with a BUG_ON().  But now I don't think we need to touch it because we
are still discussing this assumption.

In patch 4 (ext4: update extent status tree after an extent is zeroed
out) I have moved ext4_es_zeroout() into extents.c file and remove some
local variables that are only used once.  Do I need to send it out?  I
know the test has started.  Maybe I should wait a moment, and let the
tree stable before -rc2.

Regards,
                                                - Zheng
