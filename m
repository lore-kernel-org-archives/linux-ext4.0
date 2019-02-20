Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B69C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14F92147A
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550623271;
	bh=S8yzXngNnQFjRAdUVJMumVc11J8zMNKj/klUOncqN2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lVPehHSfiFyDf/q5rlR3jiksHFAoVLFUo+xGtJFXbD5uIeURs73GdObf2iHwY88Ww
	 6x+q6RyE7VXqTbZged4G5tndYmzXdScess/LyVQiw5jWtu62myf0WtEbGapyiVfAff
	 lrrQndRcYM6AfRp9MELJD3CHk4G0E7PQVJTtSDCA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfBTAlK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfBTAlK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 19:41:10 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675F821738;
        Wed, 20 Feb 2019 00:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550623269;
        bh=S8yzXngNnQFjRAdUVJMumVc11J8zMNKj/klUOncqN2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MHgodClx7clxlrEq5VZfCnE2oPXqY5a+Kfr/EbhWfHu2uoBM6cLPBt5uD8C52bz6w
         ubq7tbWcSH3VEgD9nUwzQLkmkatq+5hWOn1Z5n+vi2PR4elrxAVgPIYcPdP1Ovo7Gf
         Vk8KcSfdRcSVo65oYqHSmhnPnj7bMrSu5f0gKVbo=
Date:   Tue, 19 Feb 2019 16:41:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com
Subject: Re: [RFC PATCH 00/10] Consolidate Post read processing code
Message-ID: <20190220004107.GI12177@gmail.com>
References: <20190218100433.20048-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218100433.20048-1-chandan@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 18, 2019 at 03:34:23PM +0530, Chandan Rajendra wrote:
> Based on the reviews provided for this patchset, I
> will change F2FS to use mpage_readpage[s] and post the next version of
> this patchset to linux-fsdevel mailing list.

Is that really possible?  F2FS has other functionality in its ->readpages(),
such as support for filesystems that use multiple block devices.

- Eric
