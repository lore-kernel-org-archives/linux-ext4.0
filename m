Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5986C11F69
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 16:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC1061433
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 16:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhF3QcO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 12:32:14 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35079 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229510AbhF3QcN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 12:32:13 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15UGTe4K004092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 12:29:41 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8D79415C3C8E; Wed, 30 Jun 2021 12:29:40 -0400 (EDT)
Date:   Wed, 30 Jun 2021 12:29:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/9] ext4/306: Add -b blocksize parameter too to avoid
 failure with DAX config
Message-ID: <YNyb9Ey1nlalA8Z9@mit.edu>
References: <cover.1623651783.git.riteshh@linux.ibm.com>
 <280020a9d6791ad4fc1c51bef9c20771f6791d69.1623651783.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <280020a9d6791ad4fc1c51bef9c20771f6791d69.1623651783.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 14, 2021 at 11:58:07AM +0530, Ritesh Harjani wrote:
> mkfs.ext4 by default uses 4K blocksize. On DAX config with a 64K
> pagesize platform (PPC64), this will fail to mount since DAX requires bs
> == ps.
> Hence add the -b blocksize paramter in ext4/306.
> 
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Looks good, thanks.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

					- Ted
