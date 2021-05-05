Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F24C433B4
	for <linux-ext4@archiver.kernel.org>; Wed,  5 May 2021 16:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB61160FD9
	for <linux-ext4@archiver.kernel.org>; Wed,  5 May 2021 16:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbhEEQUo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 5 May 2021 12:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233830AbhEEQUn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 May 2021 12:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E4F46121F;
        Wed,  5 May 2021 16:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620231587;
        bh=fT7+zpvoWRmNytMZL2ErSfKueKL5e/EoY6lsi8pRg/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ACK3h/Z1y1ei7RhZZmJay3wwC2r70Mkq1UGqC9m+8ot1a05qF/bm3MPpdKXJeY3q5
         1FsDEnX0pFhV+lJYGdVNxGlfHrIm/9uu5hu0N4BWVohSfusDQdQQCch0FP/9kCrmoG
         8mPufec4nnVbS/NabyXAQ3nAI3MGYTaA5NiVxQjp+uiSk56q3E4KwkqW9CAN58egCV
         7S6hFJZMtBy4VS4/HfaKFW6SMj9sIj9yeBJs16kHMDxv9Ja4l9nPKLJsSuhdTmm4Hw
         qSmEkEYh18RYjL2Ww9hntexWe6QlOVLZBHOVuUufqvE9ay+NH9yOa9tTlP2mW0P31n
         eEekriI6jap5A==
Date:   Wed, 5 May 2021 09:19:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix kernel infoleak via ext4_extent_header
Message-ID: <YJLFoFDJr00SJRqa@gmail.com>
References: <20210505133011.32484-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505133011.32484-1-mail@anirudhrb.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, May 05, 2021 at 07:00:10PM +0530, Anirudh Rayabharam wrote:
> Initialize eh_generation of struct ext4_extent_header to prevent leaking
> info to userspace. Fixes KMSAN kernel-infoleak bug reported by syzbot at:
> http://syzkaller.appspot.com/bug?id=78e9ad0e6952a3ca16e8234724b2fa92d041b9b8
> 
> Reported-by: syzbot+2dcfeaf8cb49b05e8f1a@syzkaller.appspotmail.com
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>

Can you include a "Fixes:" tag?

- Eric
