Return-Path: <SRS0=nvKl=4I=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E86C3404C
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2448524670
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgBTEea (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:30 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37402 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727476AbgBTEea (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Feb 2020 23:34:30 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01K4YMgv020808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Feb 2020 23:34:23 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 1685F4211EF; Wed, 19 Feb 2020 23:34:22 -0500 (EST)
Date:   Wed, 19 Feb 2020 23:34:22 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Jitindar SIngh, Suraj" <surajjs@amazon.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>
Subject: Re: [PATCH RFC] ext4: fix potential race between online resizing and
 write operations
Message-ID: <20200220043422.GB476845@mit.edu>
References: <20200215233817.GA670792@mit.edu>
 <6ad43fbad38c8f986f35995ed61f9077abd3b0cc.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ad43fbad38c8f986f35995ed61f9077abd3b0cc.camel@amazon.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 19, 2020 at 03:09:07AM +0000, Jitindar SIngh, Suraj wrote:
> 
> One comment below where I think you free the wrong object.

Yes, I had sent a self-correction about that mistake earlier in this
thread.

> With that fixed up:
> Tested-by: Suraj Jitindar Singh <surajjs@amazon.com>

Thanks for testing the patch and confirming that it fixes the problem
you found!

							- Ted
