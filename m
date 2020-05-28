Return-Path: <SRS0=C1oI=7K=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0146C433E1
	for <linux-ext4@archiver.kernel.org>; Thu, 28 May 2020 14:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C716D207D3
	for <linux-ext4@archiver.kernel.org>; Thu, 28 May 2020 14:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391013AbgE1O0o (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 May 2020 10:26:44 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47150 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390932AbgE1O0o (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2020 10:26:44 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04SEQdMR023768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 10:26:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2D941420304; Thu, 28 May 2020 10:26:39 -0400 (EDT)
Date:   Thu, 28 May 2020 10:26:39 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: add casefold flag to EXT4_INODE_* flags
Message-ID: <20200528142639.GA703171@mit.edu>
References: <20200510215252.87833-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510215252.87833-1-ebiggers@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, May 10, 2020 at 02:52:52PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> No one currently needs EXT4_INODE_CASEFOLD, but add it to keep the
> EXT4_INODE_* definitions in sync with the EXT4_*_FL definitions.
> 
> Also make it clearer that the casefold flag is only for directories.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
