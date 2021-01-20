Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDCBC433E9
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Jan 2021 05:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD2A23132
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Jan 2021 05:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbhATE7Z (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Jan 2021 23:59:25 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41360 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729266AbhATE5a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jan 2021 23:57:30 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10K4ufkl022052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 23:56:41 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0289115C35F5; Tue, 19 Jan 2021 23:56:40 -0500 (EST)
Date:   Tue, 19 Jan 2021 23:56:40 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] mke2fs: Escape double quotes when parsing mke2fs.conf
Message-ID: <YAe4CC5nGdjhJCq+@mit.edu>
References: <20201102142631.87627-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102142631.87627-1-lczerner@redhat.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Nov 02, 2020 at 03:26:31PM +0100, Lukas Czerner wrote:
> Currently, when constructing the <default> configuration pseudo-file using
> the profile-to-c.awk script we will just pass the double quotes as they
> appear in the mke2fs.conf.
> 
> This is problematic, because the resulting default_profile.c will either
> fail to compile because of syntax error, or leave the resulting
> configuration invalid.

Applied, thanks.

					- Ted
