Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44783C433ED
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Apr 2021 16:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212ED611B0
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Apr 2021 16:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352593AbhDNQHH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 14 Apr 2021 12:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352587AbhDNQHF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 14 Apr 2021 12:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF9F6112F;
        Wed, 14 Apr 2021 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618416404;
        bh=bHtZ7nxyQFALxJLyz2Lob7sOa/P681tKImWQcIl3QOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exhKN5iKCIbTb9Bz0ntxlYbGh82AmLE3VIk7MkKG/0ReewpRpjQNk927DZ+KkUdOx
         99KzTCZ89edxXMJwbnGVwAaQJz4uTEhZjYVbXc0fvlotIfY5gHchyKXpQAZGPpAEme
         Bw5MQthZG+GnxZZl46y5b95bVy4e2IUNDHw714D05OJsEwHPDUItw04NsQD8efrxe4
         6/EIfvk4kUGsiw4cCkvmoqzF74RR3oEPzDfk5igIbmdfvCMiYikiGA2EmX6ZB7cNHl
         YzEfFsYlhvpheouEq3korpISK/F0sWOxyi3v0t/tQnZGp7S4riYU97DJpzVjiD2WVu
         FqRgX0LuKDT9Q==
From:   Mark Brown <broonie@kernel.org>
To:     Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, brendanhiggins@google.com,
        netdev@vger.kernel.org, davidgow@google.com, rafael@kernel.org,
        mptcp@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
        geert@linux-m68k.org, tytso@mit.edu, skhan@linuxfoundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, mathew.j.martineau@linux.intel.com
Subject: Re: (subset) [PATCH v2 0/6] kunit: Fix formatting of KUNIT tests to meet the standard
Date:   Wed, 14 Apr 2021 17:06:19 +0100
Message-Id: <161841601730.20953.13768721892830917031.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1618388989.git.npache@redhat.com>
References: <cover.1618388989.git.npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 14 Apr 2021 04:58:03 -0400, Nico Pache wrote:
> There are few instances of KUNIT tests that are not properly defined.
> This commit focuses on correcting these issues to match the standard
> defined in the Documentation.
> 
> Issues Fixed:
>  - tests should end in KUNIT_TEST, some fixes have been applied to
>    correct issues were KUNIT_TESTS is used or KUNIT is not mentioned.
>  - Tests should default to KUNIT_ALL_TESTS
>  - Tests configs tristate should have if !KUNIT_ALL_TESTS
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-next

Thanks!

[1/6] kunit: ASoC: topology: adhear to KUNIT formatting standard
      commit: b5fb388da472a69858355560d803602e0ace1006

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
