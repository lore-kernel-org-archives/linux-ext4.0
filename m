Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3B6C43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 16:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2C20206BF
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 16:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfDYQ64 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:58:56 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35208 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbfDYQ6z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 12:58:55 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3PGwler031720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Apr 2019 12:58:48 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E1F42420EEC; Thu, 25 Apr 2019 12:58:46 -0400 (EDT)
Date:   Thu, 25 Apr 2019 12:58:46 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Khazhismel Kumykov <khazhy@google.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH v2] ext4: cond_resched in work-heavy group loops
Message-ID: <20190425165846.GC4739@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Khazhismel Kumykov <khazhy@google.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz
References: <CACGdZYLCi+Or=afmBK8hbP3Ay8x8Oaqnp0Yr+jf1PoQiMc7_DQ@mail.gmail.com>
 <20190423211329.149642-1-khazhy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423211329.149642-1-khazhy@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 23, 2019 at 02:13:29PM -0700, Khazhismel Kumykov wrote:
> These functions may take a long time looping over many groups, which
> may cause issues for non-preempt kernels.
> ext4_mb_init_backend()
> ext4_setup_system_zone()
> ext4_mb_release()
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>

Thanks, applied.

					- Ted
