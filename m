Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4973C433ED
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Apr 2021 02:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A238F61028
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Apr 2021 02:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbhDFCiu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:38:50 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37835 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S243434AbhDFCit (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Apr 2021 22:38:49 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1362cYOM030877
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 5 Apr 2021 22:38:35 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7326415C3399; Mon,  5 Apr 2021 22:38:34 -0400 (EDT)
Date:   Mon, 5 Apr 2021 22:38:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Daniel Rosenberg <drosen@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com
Subject: Re: [PATCH v2 2/2] ext4: Optimize match for casefolded encrypted dirs
Message-ID: <YGvJqlcubAU/ksYk@mit.edu>
References: <20210319073414.1381041-1-drosen@google.com>
 <20210319073414.1381041-3-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319073414.1381041-3-drosen@google.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 19, 2021 at 07:34:14AM +0000, Daniel Rosenberg wrote:
> Matching names with casefolded encrypting directories requires
> decrypting entries to confirm case since we are case preserving. We can
> avoid needing to decrypt if our hash values don't match.
> 
> Signed-off-by: Daniel Rosenberg <drosen@google.com>

Thanks, applied.

						- Ted
