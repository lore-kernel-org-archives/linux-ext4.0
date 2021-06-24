Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9489BC49EA6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AEEE613EB
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFXOPM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:15:12 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49703 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229878AbhFXOPL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2021 10:15:11 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15OEClXA028393
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:12:48 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6FEEB15C3CD7; Thu, 24 Jun 2021 10:12:47 -0400 (EDT)
Date:   Thu, 24 Jun 2021 10:12:47 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Remove duplicate definition of
 ext4_xattr_ibody_inline_set()
Message-ID: <YNSS35qAivVVhRwG@mit.edu>
References: <fd566b799bbbbe9b668eb5eecde5b5e319e3694f.1622685482.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd566b799bbbbe9b668eb5eecde5b5e319e3694f.1622685482.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 03, 2021 at 07:33:02AM +0530, Ritesh Harjani wrote:
> ext4_xattr_ibody_inline_set() & ext4_xattr_ibody_set() have the exact
> same definition. Hence remove ext4_xattr_ibody_set() and all it's call
> references. Convert the callers of it to call ext4_xattr_ibody_inline_set()
> instead.
> 
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Thanks, applied.  I modified the patch to preserve
ext4_xattr_ibody_set() and remove ext4_xattr_ibody_inline_set()
instead, to make things clearer; otherwise people would wonder why the
non-inline functions were calling ext4_xattr_ibody_inline_set().

						- Ted
