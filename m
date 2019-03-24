Return-Path: <SRS0=L97M=R3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00898C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 24 Mar 2019 19:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C509120823
	for <linux-ext4@archiver.kernel.org>; Sun, 24 Mar 2019 19:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfCXTSe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 24 Mar 2019 15:18:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:59603 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726743AbfCXTSe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Mar 2019 15:18:34 -0400
Received: from callcc.thunk.org (96-72-84-49-static.hfc.comcastbusiness.net [96.72.84.49] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2OJISTm030416
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 24 Mar 2019 15:18:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C2DFD421A01; Sun, 24 Mar 2019 15:18:27 -0400 (EDT)
Date:   Sun, 24 Mar 2019 15:18:27 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL] ext4 bug fixes for 5.1
Message-ID: <20190324191827.GG5675@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
References: <20190324191431.GA29605@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324191431.GA29605@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Apologies, I forgot to add the CC's before I hit the send button....

	     	       	   - Ted

On Sun, Mar 24, 2019 at 03:14:31PM -0400, Theodore Ts'o wrote:
> The following changes since commit 0df6f46995a9fc92a6b9e591428e77527dd9609a:
> 
>   jbd2: jbd2_get_transaction does not need to return a value (2019-03-01 00:36:57 -0500)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable
> 
> for you to fetch changes up to 18915b5873f07e5030e6fb108a050fa7c71c59fb:
> 
>   ext4: prohibit fstrim in norecovery mode (2019-03-23 12:10:29 -0400)
> 
> ----------------------------------------------------------------
> Miscellaneous ext4 bug fixes for 5.1.
> 
> ----------------------------------------------------------------
> Darrick J. Wong (1):
>       ext4: prohibit fstrim in norecovery mode
> 
> Jan Kara (1):
>       ext4: avoid panic during forced reboot
> 
> Jason Yan (1):
>       ext4: remove useless ext4_pin_inode()
> 
> Jiufei Xue (1):
>       ext4: fix NULL pointer dereference while journal is aborted
> 
> Lukas Czerner (3):
>       ext4: fix data corruption caused by unaligned direct AIO
>       ext4: add missing brelse() in add_new_gdb_meta_bg()
>       ext4: report real fs size after failed resize
> 
> zhangyi (F) (2):
>       ext4: brelse all indirect buffer in ext4_ind_remove_space()
>       ext4: cleanup bh release code in ext4_ind_remove_space()
> 
>  fs/ext4/ext4_jbd2.h |  2 +-
>  fs/ext4/file.c      |  2 +-
>  fs/ext4/indirect.c  | 43 ++++++++++++++++++++++---------------------
>  fs/ext4/inode.c     | 30 ------------------------------
>  fs/ext4/ioctl.c     |  7 +++++++
>  fs/ext4/resize.c    | 17 ++++++++++++++---
>  fs/ext4/super.c     | 16 +++++++++++++---
>  7 files changed, 58 insertions(+), 59 deletions(-)
