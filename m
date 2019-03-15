Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7388BC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 04:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FBEA2186A
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 04:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfCOESg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:18:36 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37702 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725857AbfCOESf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2019 00:18:35 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F4IREC000652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Mar 2019 00:18:28 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3CF19420AA8; Fri, 15 Mar 2019 00:18:27 -0400 (EDT)
Date:   Fri, 15 Mar 2019 00:18:27 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ext4: Add missing brelse() in
 add_new_gdb_meta_bg()
Message-ID: <20190315041827.GG11334@mit.edu>
References: <20190305105400.4960-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305105400.4960-1-lczerner@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 05, 2019 at 11:53:59AM +0100, Lukas Czerner wrote:
> Currently in add_new_gdb_meta_bg() there is a missing brelse of gdb_bh
> in case ext4_journal_get_write_access() fails.
> Additionally kvfree() is missing in the same error path. Fix it by
> moving the ext4_journal_get_write_access() before the ext4 sb update as
> Ted suggested and release n_group_desc and gdb_bh in case it fails.
> 
> Fixes: 61a9c11e5e7a ("ext4: add missing brelse() add_new_gdb_meta_bg()'s error path")
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
