Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B359C433C1
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Mar 2021 21:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F3D619C7
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Mar 2021 21:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhC3VPU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 30 Mar 2021 17:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhC3VOu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Mar 2021 17:14:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D6AF619C7;
        Tue, 30 Mar 2021 21:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617138888;
        bh=taXsV73nHzdZSMOwWqsMrMRCclI86eUiaKIQFYpaPQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A1MJSQrBictwYg85BvOUWG7y9k3F+gaM/rQOQrrp0mJAlWgVpnTZOL2n5d1zB8Ruj
         syZzzOk7loPsQwB3YR3jdWTRHwBjSOA1BmWqFzQw99m2osMEvRn2MNjveKS4nfY149
         en1EFQQmYHGOjiAuCacVKI/qCLAEgTgJieueUXMH/zuopXbGAAsYAEKsFdfv9DOi9R
         D/BZYJNf9B7rCyS/Aun+CLM5dwLwMQq92OlfrD4uG1Wb2R3L2By//an+fsUA4Hr1i2
         zelrqGfKQ00fx3fSmS6XOVsu52pPlZfCZK03Tupb/3nc61pBmzUHT8n/euB3eaaFfY
         FE3srXV77AxxQ==
Date:   Tue, 30 Mar 2021 17:14:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 03/44] ext4: add reclaim checks to xattr code
Message-ID: <YGOUxw/YnRMqvlz1@sashalap>
References: <20210325112459.1926846-1-sashal@kernel.org>
 <20210325112459.1926846-3-sashal@kernel.org>
 <20210325143020.GC13673@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210325143020.GC13673@quack2.suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 25, 2021 at 03:30:20PM +0100, Jan Kara wrote:
>Sasha, just be aware that this commit was added to help tracking down a
>particular syzbot report. As such there's no point in carrying it in
>-stable but there's no big harm either... Just one patch more.

Yup, I'd rather keep it to see if we get reports of this in stable
kernels. Better a (harmless) warning than a silent corruption.

-- 
Thanks,
Sasha
