Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE7FC282DA
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088F9213A2
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 02:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDGCNz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 22:13:55 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49744 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726184AbfDGCNz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Apr 2019 22:13:55 -0400
Received: from callcc.thunk.org (225.sub-174-209-4.myvzw.com [174.209.4.225])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x372Dlcw018863
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 6 Apr 2019 22:13:49 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F097E421A11; Sat,  6 Apr 2019 18:35:21 -0400 (EDT)
Date:   Sat, 6 Apr 2019 18:35:21 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Make sanity check in mballoc more strict
Message-ID: <20190406223521.GE18897@mit.edu>
References: <20190328164117.19148-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328164117.19148-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 28, 2019 at 05:41:17PM +0100, Jan Kara wrote:
> Sanity check in mb_find_extent() only checked that returned extent does
> not extend past blocksize * 8, however it should not extend past
> EXT4_CLUSTERS_PER_GROUP(sb). This can happen when clusters_per_group <
> blocksize * 8 and the tail of the bitmap is not properly filled by 1s
> which happened e.g. when ancient kernels have grown the filesystem.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
