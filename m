Return-Path: <SRS0=E9RY=4C=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D73C47409
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Feb 2020 16:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF44024684
	for <linux-ext4@archiver.kernel.org>; Fri, 14 Feb 2020 16:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392112AbgBNQsS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:48:18 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35701 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388648AbgBNQsA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Feb 2020 11:48:00 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-101.corp.google.com [104.133.0.101] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 01EGlu0i032096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 11:47:57 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0880942032C; Fri, 14 Feb 2020 11:47:56 -0500 (EST)
Date:   Fri, 14 Feb 2020 11:47:55 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/002: remove EXT4_EOFBLOCKS_FL test
Message-ID: <20200214164755.GB439135@mit.edu>
References: <20200214164249.21868-1-enwlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214164249.21868-1-enwlinux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Feb 14, 2020 at 11:42:49AM -0500, Eric Whitney wrote:
> This test exercises obsolete ext4-specific functionality that will be
> removed in the kernel's 5.7 release.  Once that happens, ext4/002 will
> always fail, so remove the test to avoid the noise.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
