Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC6EC433DB
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Mar 2021 01:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C2461935
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Mar 2021 01:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhC3BxZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 29 Mar 2021 21:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhC3BxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Mar 2021 21:53:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E37260C41;
        Tue, 30 Mar 2021 01:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617069196;
        bh=GevyNR3XBe9JE7jNR+C8DY51gkGc4pzFml1BcSA406Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q5qJ0nFahBP6GKD/dJ8ZoylIMmracSMkrLJT/lMIaVQsirQQDmobUKooTFBmZAnPu
         aUwiEKocTK2IblXOwGicPfx1kesw3uK2nQsdYUsHfnxUiMUPKbo3T/H8G9t/0CdZIt
         hFZkDNzfyTkzmR4LWgY49O/sziwlogOrSFqsLze3HfXi4hNB0yzSGYSQ2jsYTxs7hp
         /B0Vpj7pfQxQT5cB07v69yDt1Ui/WQ+RkhTrCJoCMpyICo6Kz6yPnS1tqWwvU1mWqT
         bl7OzwZIWaIDZ8IkHPfltNPTxBNaXYgCfcTI8WxfMjcLG/G51Nr4zM9r0Z7oGC7+Aq
         gKk3hrBJYGQCg==
Date:   Mon, 29 Mar 2021 18:53:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Shreeya Patel <shreeya.patel@collabora.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        chao@kernel.org, krisman@collabora.com, drosen@google.com,
        yuchao0@huawei.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        andre.almeida@collabora.com
Subject: Re: [PATCH v5 2/4] fs: unicode: Rename function names from utf8 to
 unicode
Message-ID: <YGKEitULkZmMwk3f@gmail.com>
References: <20210329204240.359184-1-shreeya.patel@collabora.com>
 <20210329204240.359184-3-shreeya.patel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329204240.359184-3-shreeya.patel@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 30, 2021 at 02:12:38AM +0530, Shreeya Patel wrote:
> utf8data.h_shipped has a large database table which is an auto-generated
> decodification trie for the unicode normalization functions and it is not
> necessary to carry this large table in the kernel.
> Goal is to make UTF-8 encoding loadable by converting it into a module
> and adding a unicode subsystem layer between the filesystems and the
> utf8 module.
> This layer will load the module whenever any filesystem that
> needs unicode is mounted.
> utf8-core will be converted into this layer file in the future patches,
> hence rename the function names from utf8 to unicode which will denote the
> functions as the unicode subsystem layer functions and this will also be
> the first step towards the transformation of utf8-core file into the
> unicode subsystem layer file.
> 
> Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
> ---
> Changes in v5
>   - Improve the commit message.

This didn't really answer my questions about the reason for this renaming.
Aren't the functions like unicode_casefold() still tied to UTF-8 (as opposed to
e.g. supporting both UTF-8 and UTF-16)?  Is that something you're trying to
change?

- Eric
