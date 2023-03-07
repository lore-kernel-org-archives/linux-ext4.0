Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC60C6FD20
	for <linux-ext4@archiver.kernel.org>; Tue,  7 Mar 2023 19:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjCGTge (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 7 Mar 2023 14:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjCGTgN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Mar 2023 14:36:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6D27A905;
        Tue,  7 Mar 2023 11:23:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 573A3B8184E;
        Tue,  7 Mar 2023 19:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB68C4339B;
        Tue,  7 Mar 2023 19:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678216992;
        bh=7kyoS8ZgytWpoBl67Th/zqjZIXV9l0/AxtG+zXqfKgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JsQKPiLNFSZv52JQmLTDiJGOHIfWn+gpiebtotU3usFGeOzq1kkCxQHdzijBGBa6a
         aB405zKj+SRVYVoaeJIJjYBfOA1+vqApMu/c/fzd6NovCF92FBEmXW1WkCHwz1U3So
         pUPGeVso9f37se5dcjnELYJsyaGCEiJbqqFfC+RsIofoao2TJCavDBi+S2BEITiRU7
         DsayApFQtrQ1qnvtfJaqB0hzTyb7BW/cMJegFJdBCsXBH/KVml+/drYWeXjcmownRh
         4BRDCYa+6D8QqNR7RitAo45xWUJH1lA2SmIvYtUXbv9BTholZBHHRKDvqzwk6x7aBR
         faEZN3VpW/hjQ==
Date:   Tue, 7 Mar 2023 19:23:10 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6.1 788/885] ext4: Fix possible corruption when moving a
 directory
Message-ID: <ZAePHuuAGo7I1VOc@gmail.com>
References: <20230307170001.594919529@linuxfoundation.org>
 <20230307170036.133148515@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307170036.133148515@linuxfoundation.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 07, 2023 at 06:02:02PM +0100, Greg Kroah-Hartman wrote:
> From: Jan Kara <jack@suse.cz>
> 
> commit 0813299c586b175d7edb25f56412c54b812d0379 upstream.
> 
> When we are renaming a directory to a different directory, we need to
> update '..' entry in the moved directory. However nothing prevents moved
> directory from being modified and even converted from the inline format
> to the normal format. When such race happens the rename code gets
> confused and we crash. Fix the problem by locking the moved directory.
> 
> CC: stable@vger.kernel.org
> Fixes: 32f7f22c0b52 ("ext4: let ext4_rename handle inline dir")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20230126112221.11866-1-jack@suse.cz
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This commit has a reported regression
(https://lore.kernel.org/linux-ext4/5efbe1b9-ad8b-4a4f-b422-24824d2b775c@kili.mountain),
so probably it should not be backported quite yet.

- Eric
