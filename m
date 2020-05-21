Return-Path: <SRS0=JSyQ=7D=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E4DC433DF
	for <linux-ext4@archiver.kernel.org>; Thu, 21 May 2020 14:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23663206F6
	for <linux-ext4@archiver.kernel.org>; Thu, 21 May 2020 14:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgEUO7x (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 May 2020 10:59:53 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56047 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728162AbgEUO7x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 May 2020 10:59:53 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04LExmiI019032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 May 2020 10:59:49 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C299B420304; Thu, 21 May 2020 10:59:48 -0400 (EDT)
Date:   Thu, 21 May 2020 10:59:48 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/4] ext4: clean up ext4_ext_handle_unwritten_extents()
Message-ID: <20200521145948.GD2939819@mit.edu>
References: <20200430185320.23001-1-enwlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430185320.23001-1-enwlinux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 30, 2020 at 02:53:16PM -0400, Eric Whitney wrote:
> Changes made to ext4 over time have resulted in some cruft accumulating
> in ext4_ext_handle_unwritten_extents().  This patch series removes
> some dead and some redundant code, simplifies and corrects some error
> handling, and adds explicit error logging when an unexpected internal
> error or file system corruption may have occurred.
> 
> Eric Whitney (4):
>   ext4: remove dead GET_BLOCKS_ZERO code
>   ext4: remove redundant GET_BLOCKS_CONVERT code
>   ext4: clean up GET_BLOCKS_PRE_IO error handling
>   ext4: clean up ext4_ext_convert_to_initialized() error handling
> 
>  fs/ext4/extents.c | 81 ++++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 36 deletions(-)

Thanks, I've applied this patch series.

						- Ted
