Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA00C11F68
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 17:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319AB61166
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 17:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhF3RJm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 13:09:42 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40563 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232278AbhF3RJm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 13:09:42 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15UH773G019551
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 13:07:08 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 91D5315C3C8E; Wed, 30 Jun 2021 13:07:07 -0400 (EDT)
Date:   Wed, 30 Jun 2021 13:07:07 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 7/9] generic/620: Remove -b blocksize option for ext4
Message-ID: <YNyku9CJ3YImhkMA@mit.edu>
References: <cover.1623651783.git.riteshh@linux.ibm.com>
 <8b3d5afe83ee6d1d35f57914a9b0cfa4b5bb4361.1623651783.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b3d5afe83ee6d1d35f57914a9b0cfa4b5bb4361.1623651783.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 14, 2021 at 11:58:11AM +0530, Ritesh Harjani wrote:
> ext4 with 64k blocksize fails with below error for this given test which
> requires dmhugedisk. Also since dax is not supported for this test, so
> make sure to remove -b option, if set by config file for ext4 FSTYP for
> the test to then use 4K blocksize by default.
> 
> mkfs.ext4: Input/output error while writing out and closing file system
> 
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Looking at this test, I'm not convinced it actually does the right
thing when the block size is 64k, since the whole point is to test
what happens when the block number > INT_MAX.  So we should be able to
fix the block size to be 1k, which would allow us to use a smaller
dmhugedisk, and then skip this test if dax is enabled.

OTOH, generic/620 runs pretty quicky, so perhaps it's better to do
thie quick fix: hardcode the block size to 4k, and then skip it if dax
&& page_size != 4k.

					- Ted
