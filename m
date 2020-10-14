Return-Path: <SRS0=fwjS=DV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0FFC433DF
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Oct 2020 15:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5232222F
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Oct 2020 15:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgJNPx5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:53:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36283 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726307AbgJNPx4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2020 11:53:56 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 09EFrq0t026456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Oct 2020 11:53:53 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 44521420107; Wed, 14 Oct 2020 11:53:52 -0400 (EDT)
Date:   Wed, 14 Oct 2020 11:53:52 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH] test-appliance: add lz4 package
Message-ID: <20201014155352.GD18373@mit.edu>
References: <20201011175325.3419-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201011175325.3419-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Oct 11, 2020 at 10:53:25AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This is needed for the test f2fs/002, which tests f2fs compression in
> combination with encryption.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.  I ammended this patch to also add the lz4 package to
gce-xfstests-bld.sh.

I suppose at some point we should we refactor out the package lists
in  xfstests-packages and gce-xfstests-bld.sh; this would require
making gce-xfstests-bld.sh a generated file, however.

       			     	       - Ted
