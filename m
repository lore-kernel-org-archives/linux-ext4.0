Return-Path: <SRS0=qVE9=ZD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A6BC43331
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Nov 2019 22:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FDB620674
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Nov 2019 22:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfKKWLq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Nov 2019 17:11:46 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44912 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbfKKWLq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Nov 2019 17:11:46 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xABMBSbm023762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Nov 2019 17:11:29 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 785494202FD; Mon, 11 Nov 2019 17:11:28 -0500 (EST)
Date:   Mon, 11 Nov 2019 17:11:28 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     dan.carpenter@oracle.com, jack@suse.cz, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] ext4: Add error handling for io_end_vec struct
 allocation
Message-ID: <20191111221128.GA23273@mit.edu>
References: <20191106082505.GA31923@mwanda>
 <20191106093809.10673-1-riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106093809.10673-1-riteshh@linux.ibm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Nov 06, 2019 at 03:08:09PM +0530, Ritesh Harjani wrote:
> This patch adds the error handling in case of any memory allocation
> failure for io_end_vec. This was missing in original
> patch series which enables dioread_nolock for blocksize < pagesize.
> 
> Fixes: c8cc88163f40 ("ext4: Add support for blocksize < pagesize in dioread_nolock")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>

Applied, thanks.

					- Ted
