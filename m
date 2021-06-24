Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3888C49EA5
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 16:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C32756124C
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 16:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhFXQ07 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jun 2021 12:26:59 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42088 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229721AbhFXQ06 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2021 12:26:58 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15OGOYEs020085
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 12:24:34 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D34CE15C3CD7; Thu, 24 Jun 2021 12:24:33 -0400 (EDT)
Date:   Thu, 24 Jun 2021 12:24:33 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: notify sysfs on errors_count value change
Message-ID: <YNSxwR2GkUd6Dz9B@mit.edu>
References: <20210611140209.28903-1-jonathan.davies@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611140209.28903-1-jonathan.davies@nutanix.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jun 11, 2021 at 02:02:08PM +0000, Jonathan Davies wrote:
> After s_error_count is incremented, signal the change in the
> corresponding sysfs attribute via sysfs_notify. This allows userspace to
> poll() on changes to /sys/fs/ext4/*/errors_count.
> 
> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>

Applied, thanks.

					- Ted
