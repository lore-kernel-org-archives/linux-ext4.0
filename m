Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FDDC77B7C
	for <linux-ext4@archiver.kernel.org>; Wed, 10 May 2023 18:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbjEJS7R (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 May 2023 14:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjEJS7P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 May 2023 14:59:15 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699B710D3
        for <linux-ext4@vger.kernel.org>; Wed, 10 May 2023 11:59:14 -0700 (PDT)
Received: from letrec.thunk.org (vancouverconventioncentre.com [72.28.92.215] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 34AIx6e0021568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 14:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1683745149; bh=hYe5mbgVey+MBUg28ndipfbchjF7PO883Q+kdEbNMhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=kqISOQ6ov8yjxe2M3SFXkCfz9KnSa85jc8WTj9p5g/bMlMsXujMQn2Cm/3Qa6pT1S
         l+bdbdPlMygfaC+bWQiGpGAd++Zwhc8RvNanOOcZ03BvgbDJlLIeQOS91i0L67Cwq5
         Vw1ODVzzgpVzL7tf8hbTMvCHEA6I0qywR0zYpdHcWFVniYVFdrf48ydSnDXsoreh0m
         flzt6xE/NWMfYLArfCKjlU4fe7Bfj0s+sh0EsN6CyBNbpVwTYB7W+QlW+/lX3u3hZ1
         dmv7mjaTyoQ8hMDmpOaFv1OdVzZBdgCdXKIx31OE5H8v4rzFoSyZZphwxHSySpgZie
         fXcP7JlQoHZLg==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id A54258C03A8; Wed, 10 May 2023 14:59:05 -0400 (EDT)
Date:   Wed, 10 May 2023 14:59:05 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+3c6cac1550288f8e7060@syzkaller.appspotmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ext4?] BUG: sleeping function called from invalid
 context in alloc_buffer_head
Message-ID: <ZFvpefM2MgrdJ7v4@mit.edu>
References: <0000000000004c3e6b05fb414be2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000004c3e6b05fb414be2@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

#syz set: subsystems mm
