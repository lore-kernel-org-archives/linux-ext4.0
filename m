Return-Path: <SRS0=+eI2=2E=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08228C43603
	for <linux-ext4@archiver.kernel.org>; Sat, 14 Dec 2019 22:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE9962067C
	for <linux-ext4@archiver.kernel.org>; Sat, 14 Dec 2019 22:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfLNWcj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 14 Dec 2019 17:32:39 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39584 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726687AbfLNWci (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Dec 2019 17:32:38 -0500
Received: from callcc.thunk.org (ec2-3-216-189-230.compute-1.amazonaws.com [3.216.189.230])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBEMWOtg023206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Dec 2019 17:32:25 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C264F4207DF; Sat, 14 Dec 2019 17:32:23 -0500 (EST)
Date:   Sat, 14 Dec 2019 17:32:23 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Miao Xie <miaoxie@huawei.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4: unlock on error in ext4_expand_extra_isize()
Message-ID: <20191214223223.GA448096@mit.edu>
References: <20191213113237.GF15474@quack2.suse.cz>
 <20191213185010.6k7yl2tck3wlsdkt@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213185010.6k7yl2tck3wlsdkt@kili.mountain>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Dec 13, 2019 at 09:50:11PM +0300, Dan Carpenter wrote:
> We need to unlock the xattr before returning on this error path.
> 
> Fixes: c03b45b853f5 ("ext4, project: expand inode extra size if possible")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

					- Ted
