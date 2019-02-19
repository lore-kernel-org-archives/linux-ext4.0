Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB789C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 21:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A545F2147C
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 21:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550611039;
	bh=AiSdL4AcfSr5Hz35F/sSGR7Ddt5qWIwcnikMO5AcYrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eD66sQmROjHM8fsyk5dbrTloOnK+grYrEIy9e7mmr20kRoB4fXpHLHJfPo380MUjV
	 9ZFzWhClvPbWKcmY5eALY9qYZH644V8A6GRbZ/ZDC/zbLAJ8QQCuXNFDybzI2D3Y7t
	 N+7Bm/rwKWJGQ9OhWHUX3PwX2mXvcwzM09I38rvs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfBSVRT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 16:17:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbfBSVRT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 16:17:19 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD5352146F;
        Tue, 19 Feb 2019 21:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550611038;
        bh=AiSdL4AcfSr5Hz35F/sSGR7Ddt5qWIwcnikMO5AcYrM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNB0I68mAIMh4es8xCMsK2oprOb2IBvQwJ6KM2cGsliONUUU7ATm6VJkyV0TNGb/U
         ENb8eZcuCAJ0s4sxoUx9S5KQFeDWeNJaNqCoEATXLb3TWMIUITjHLdWSlI57jVdVK4
         kzohV2t3HUKMlse3f3ZlG6I3ro8HJZE2bHDUt2m8=
Date:   Tue, 19 Feb 2019 13:17:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com
Subject: Re: [RFC PATCH 00/10] Consolidate Post read processing code
Message-ID: <20190219211715.GA12177@gmail.com>
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

Hi Chandan,

On Mon, Feb 18, 2019 at 03:34:23PM +0530, Chandan Rajendra wrote:
> This patchset moves the "post read processing" code into a file of its
> own and gets the generic do_mpage_readpge() to make use of the
> functionality provided. With these changes in place, the patchset
> changes Ext4 to use mpage_readpage[s] instead of its own custom
> ext4_readpages() function. This is done to reduce duplicity of code
> across filesystems. Based on the reviews provided for this patchset, I
> will change F2FS to use mpage_readpage[s] and post the next version of
> this patchset to linux-fsdevel mailing list.
> 
> The patchset also includes patches from previous postings i.e.
> patches to replace per-filesystem encryption config options with a
> single config option that affects all filesystems making use of
> fscrypt code.
> 
> Chandan Rajendra (10):
>   ext4: use IS_ENCRYPTED() to check encryption status
>   f2fs: use IS_ENCRYPTED() to check encryption status
>   fscrypt: remove filesystem specific build config option
>   Consolidate "post read processing" into a new file
>   fsverity: Add call back to decide if verity check has to be performed
>   Introduce REQ_POST_READ_PROC bio flag
>   fsverity: Add call back to determine readpage limit
>   fsverity: Add call back to verify file holes
>   fs/mpage.c: Integrate post read processing
>   ext4: Wire up ext4_readpage[s] to use mpage_readpage[s]
> 

Thanks for working on this!  This will also make it much easier to support
block_size != PAGE_SIZE in ext4 encryption, right?  I think this is the best
path forward, but I'll take a closer look at your new patches.

FYI regarding practical matters, merging fs-verity was delayed due to
disagreement about the API.  See https://lwn.net/Articles/775872/.

We don't have to wait for fs-verity for your initial fscrypt changes, though:

	ext4: use IS_ENCRYPTED() to check encryption status
	f2fs: use IS_ENCRYPTED() to check encryption status
	fscrypt: remove filesystem specific build config option

So, a couple weeks ago Ted and I already queued those three patches in
fscrypt.git (https://git.kernel.org/pub/scm/linux/kernel/git/tytso/fscrypt.git
branch "master", though we plan to change the repo soon) for the upcoming merge
window, based on upstream rather than fs-verity.  Are you fine with that?

I also suggest adding linux-fsdevel to the Cc given the fs/*.c changes.

Thanks!

- Eric
