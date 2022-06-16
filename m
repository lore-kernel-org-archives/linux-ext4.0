Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB860C43334
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jun 2022 12:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiFPMtv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 Jun 2022 08:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiFPMtu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jun 2022 08:49:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A521AD96
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jun 2022 05:49:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B0B9E1F8C1;
        Thu, 16 Jun 2022 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655383787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EyduPko3ZtALa4oOrrk1ZaEmySl+TBijpQJfEjnfkdA=;
        b=0fESLNHoG50xvsYY5inQK0WAf4j55uU432NB/q2WAetioYQ9vvbHXwuJSWRRWHR7yx/8W4
        oMgkN/DoZeb7NxaNPNRWtCW2dRlUJmPsAYJDlM7od7NKjORuo+GHIX3GekvtcQaD4S8q+4
        v3S1Mi5vQyy/xOwRT91acvoPKigsaFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655383787;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EyduPko3ZtALa4oOrrk1ZaEmySl+TBijpQJfEjnfkdA=;
        b=BNTHxPIMheIf4WC7cPeVkn+OnzxDm/63q7yqHtArck42LF6WfcpWi5c3fgqyIT8bYOU85b
        9/RYDOZX5Jh/KXBw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8C3572C141;
        Thu, 16 Jun 2022 12:49:47 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F23D0A062E; Thu, 16 Jun 2022 14:49:46 +0200 (CEST)
Date:   Thu, 16 Jun 2022 14:49:46 +0200
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <ritesh.list@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/10 v2] ext4: Fix possible fs corruption due to xattr
 races
Message-ID: <20220616124946.pzkhx6q6nzrvuhxy@quack3.lan>
References: <20220614124146.21594-1-jack@suse.cz>
 <20220616115440.ryjyecrwprgfoxp2@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616115440.ryjyecrwprgfoxp2@riteshh-domain>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 16-06-22 17:24:40, Ritesh Harjani wrote:
> On 22/06/14 06:05PM, Jan Kara wrote:
> > Hello,
> >
> > this is the second version of my patches to fix the race in ext4 xattr handling
> > that led to assertion failure in jbd2 Ritesh has reported. The series is
> > completely reworked. This time it passes beating with "stress-ng --xattr 16".
> > Also I'm somewhat happier about the current solution because, although it is
> > still not trivial to use mbcache correctly, it is at least harder to use it
> > in a racy way :). Please let me know what you think about this series.
> 
> I have tested this on my setup where I was able to reproduce the problem with
> stress-ng. It ran for several hours and also passed fstests (quick).
> 
> So feel free to -
> Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks for testing!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
