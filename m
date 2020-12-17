Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1102C4361B
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 16:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E49923977
	for <linux-ext4@archiver.kernel.org>; Thu, 17 Dec 2020 16:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgLQQJe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 17 Dec 2020 11:09:34 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58150 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727566AbgLQQJd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Dec 2020 11:09:33 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BHG8iXU016254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 11:08:44 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C51E7420280; Thu, 17 Dec 2020 11:08:43 -0500 (EST)
Date:   Thu, 17 Dec 2020 11:08:43 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org,
        harshad shirwadkar <harshadshirwadkar@gmail.com>
Subject: Re: [PATCH 8/8] ext4: Drop ext4_handle_dirty_super()
Message-ID: <X9uCi7EqYHRoxPXl@mit.edu>
References: <20201216101844.22917-1-jack@suse.cz>
 <20201216101844.22917-9-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216101844.22917-9-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 16, 2020 at 11:18:44AM +0100, Jan Kara wrote:
> The wrapper is now useless since it does what
> ext4_handle_dirty_metadata() does. Just remove it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
