Return-Path: <SRS0=EsIP=Z7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD64C3F68F
	for <linux-ext4@archiver.kernel.org>; Mon,  9 Dec 2019 00:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F5D206F4
	for <linux-ext4@archiver.kernel.org>; Mon,  9 Dec 2019 00:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfLIAM1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 8 Dec 2019 19:12:27 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33498 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726422AbfLIAM1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Dec 2019 19:12:27 -0500
Received: from callcc.thunk.org (ec2-52-55-121-20.compute-1.amazonaws.com [52.55.121.20])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xB90CFYW000391
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 8 Dec 2019 19:12:19 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B2F87421A48; Sun,  8 Dec 2019 19:12:11 -0500 (EST)
Date:   Sun, 8 Dec 2019 19:12:11 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: Fix ext4_empty_dir() for directories with holes
Message-ID: <20191209001211.GA9343@mit.edu>
References: <20191202170213.4761-1-jack@suse.cz>
 <20191202170213.4761-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202170213.4761-2-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Dec 02, 2019 at 06:02:12PM +0100, Jan Kara wrote:
> Function ext4_empty_dir() doesn't correctly handle directories with
> holes and crashes on bh->b_data dereference when bh is NULL. Reorganize
> the loop to use 'offset' variable all the times instead of comparing
> pointers to current direntry with bh->b_data pointer. Also add more
> strict checking of '.' and '..' directory entries to avoid entering loop
> in possibly invalid state on corrupted filesystems.
> 
> References: CVE-2019-19037
> CC: stable@vger.kernel.org
> Fixes: 4e19d6b65fb4 ("ext4: allow directory holes")
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
