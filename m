Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311E5C3DA66
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Aug 2023 12:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242442AbjHYMb2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Aug 2023 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjHYMa5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Aug 2023 08:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2385C2681;
        Fri, 25 Aug 2023 05:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E8D862734;
        Fri, 25 Aug 2023 12:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C119DC433C7;
        Fri, 25 Aug 2023 12:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692966573;
        bh=tsDSGaLNSBiExvhpNr4zfFfKEE0pWg81crOLSdA1zFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbuWwU9TInD5uV7V5U2W26byAo6kSZPL8ifYVG6J0mXxF1gGMHX0WgbaABPgncCt5
         yijND4meu38IGiUhAOXB8mXEMRADX2NBEJah4a/nf6tDD4nXGiTENPBfDuenVRtCsF
         PUsM1OE0stU1kRp6CgObav3K5lA8PZuoGt25YxzV+XK7jJQuWrBTNyZtHbVc1AwpUn
         FuKVsxpOy+OTHLhnUN4VbcdkYv08OFHWFukHeoVAjFq6xefFG24JpPR+DeMtNJ8+oG
         RnzvbcOhsECOHVeeWa6pmMGFjpPtqjJAxLQYnnmU+0tAC01lNF7Q8IEPVc5Xmsyn42
         df3RIPGjff1tA==
Date:   Fri, 25 Aug 2023 14:29:29 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/29] ext4: Convert to bdev_open_by_dev()
Message-ID: <20230825-lamawolle-parkhaus-345ad448fd78@brauner>
References: <20230818123232.2269-1-jack@suse.cz>
 <20230823104857.11437-22-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230823104857.11437-22-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Aug 23, 2023 at 12:48:33PM +0200, Jan Kara wrote:
> Convert ext4 to use bdev_open_by_dev() and pass the handle around.
> 
> CC: <linux-ext4@vger.kernel.org>
> CC: Ted Tso <tytso@mit.edu>
> Acked-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
