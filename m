Return-Path: <SRS0=LMHP=6X=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0931C54E49
	for <linux-ext4@archiver.kernel.org>; Sat,  9 May 2020 12:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A002924956
	for <linux-ext4@archiver.kernel.org>; Sat,  9 May 2020 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589027452;
	bh=8zHjGqPPA3gdmrfKFmgQeUooIbN2p4/RDvSS7ZJuRFk=;
	h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=Qy788XscqmmBnANiOrqmwocXMiRjjVHhAlpSXHeGmSzuRu4xCLiqDQfyEd3ZNQPv4
	 3oZiUmQr+m+vSjUnE39D6Ggeuir+zaHPgXuH+36l/GBQsfO2S3rxpL3FRsnmuRpDHw
	 yV8msNwGgNGU6qnSeSTAdvAwYs5EHeos1Ub1q6ZM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgEIMaw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 9 May 2020 08:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgEIMav (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 9 May 2020 08:30:51 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A3B624958;
        Sat,  9 May 2020 12:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027451;
        bh=8zHjGqPPA3gdmrfKFmgQeUooIbN2p4/RDvSS7ZJuRFk=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=V/xA1murxXLh4I2F6b4ljJDJWxSiKo1m6/GFc29tucX9EeLa1PkNE6z3D3PuAnUh+
         SSlOOUZmwMV3PxpfVOziop7i/cZt8otZcGDmOzXJ9B3lepnj7rooTglZgTY4zB1/fb
         LDC8Mxqd9vWm8b1gilVNz2ooZ7VnOhaMpXOIim8I=
Date:   Sat, 09 May 2020 12:30:50 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@google.com>
To:     linux-ext4@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-fsdevel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix race between ext4_sync_parent() and rename()
In-Reply-To: <20200506183140.541194-1-ebiggers@kernel.org>
References: <20200506183140.541194-1-ebiggers@kernel.org>
Message-Id: <20200509123051.4A3B624958@mail.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: d59729f4e794 ("ext4: fix races in ext4_sync_parent()").

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222, v4.4.222.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Build OK!
v4.14.179: Build OK!
v4.9.222: Build OK!
v4.4.222: Failed to apply! Possible dependencies:
    6ae4c5a69877 ("ext4: cleanup ext4_sync_parent()")
    78d962510796 ("ext4: respect the nobarrier mount option in nojournal mode")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
