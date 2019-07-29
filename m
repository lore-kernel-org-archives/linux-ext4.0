Return-Path: <SRS0=mPdH=V2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925F0C433FF
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Jul 2019 03:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 576DB2077C
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Jul 2019 03:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564369949;
	bh=BKKX38xiDXht50rJXIv/FdzcKNnwvbBHros6Vxt/Dr4=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=xOyWb8ViEronniJsF/sY66aPCY0K0GPRKeptYtHuc9i71cwDji75i2GCZIEQAXURy
	 5UKEfodHIUEhuKMEYc29RArjIS6kbZZHPjVQsytHvQwLYZrCRl2nRUhzx3useYw4Yd
	 oVyhDoYNqjHd9elD+PfVm6oLwThRPblZLgjBKYXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfG2DM2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Jul 2019 23:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbfG2DM2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 28 Jul 2019 23:12:28 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 971712075B;
        Mon, 29 Jul 2019 03:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564369947;
        bh=BKKX38xiDXht50rJXIv/FdzcKNnwvbBHros6Vxt/Dr4=;
        h=Date:From:To:Cc:Subject:From;
        b=Uv3bgux8g0V+8dnXCvzMxhyzS1p+M6PvMZdIWx1U1w9zrjIsFYx7orxJKwDnK9EJJ
         Ii3MOwPd5uYhowVROKEvWWWGm5k2c9PwZaCtsx0fJt0lICeUvecfyDrtinKF4nozAL
         YJht4eyjZJc1Ub1fcfu8QGZSapdLkfH6jqhL8vKI=
Date:   Sun, 28 Jul 2019 20:12:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-next@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Add fsverity tree to linux-next
Message-ID: <20190729031226.GA2252@sol.localdomain>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Stephen,

Can you please add the fsverity tree to linux-next?

        https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git#fsverity

This branch contains the latest fs-verity patches
(https://lore.kernel.org/linux-fsdevel/20190722165101.12840-1-ebiggers@kernel.org/T/#u).
We are planning a pull request for 5.4.

Please use as contacts:

        Eric Biggers <ebiggers@kernel.org>
        Theodore Y. Ts'o <tytso@mit.edu>

Thanks!

- Eric
