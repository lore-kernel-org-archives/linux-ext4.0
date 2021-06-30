Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2916C11F65
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 17:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C07316141A
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jun 2021 17:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhF3RV6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jun 2021 13:21:58 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42376 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229963AbhF3RV5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2021 13:21:57 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15UHJO6x024330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 13:19:25 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 64BEF15C3C8E; Wed, 30 Jun 2021 13:19:24 -0400 (EDT)
Date:   Wed, 30 Jun 2021 13:19:24 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 8/9] common/attr: Cleanup end of line whitespaces issues
Message-ID: <YNynnN5NeyQciy6w@mit.edu>
References: <cover.1623651783.git.riteshh@linux.ibm.com>
 <9c2d87969d29f34e0939fa3a524886e343fb96bb.1623651783.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c2d87969d29f34e0939fa3a524886e343fb96bb.1623651783.git.riteshh@linux.ibm.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 14, 2021 at 11:58:12AM +0530, Ritesh Harjani wrote:
> This patch clears the end of line whitespace issues in this file.
> Mostly since many kernel developers also keep this editor config to clear
> any end of line whitespaces on file save.
> 
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
