Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E5CC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E85206BA
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfCODrt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:47:49 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33002 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726791AbfCODrs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 23:47:48 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F3ldZ0026069
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Mar 2019 23:47:39 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0BD2A420AA8; Thu, 14 Mar 2019 23:47:39 -0400 (EDT)
Date:   Thu, 14 Mar 2019 23:47:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Avoid panic during forced reboot
Message-ID: <20190315034738.GD11334@mit.edu>
References: <20190312094906.5974-1-jack@suse.cz>
 <20190312122106.xzko4pmtpyreq6ih@pathway.suse.cz>
 <20190312160139.GC32521@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190312160139.GC32521@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> From 15b830d4e877ed908c733ab3219801d1026af256 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 12 Mar 2019 10:38:19 +0100
> Subject: [PATCH] ext4: Avoid panic during forced reboot
> 
> When admin calls "reboot -f" - i.e., does a hard system reboot by
> directly calling reboot(2) - ext4 filesystem mounted with errors=panic
> can panic the system. This happens because the underlying device gets
> disabled without unmounting the filesystem and thus some syscall running
> in parallel to reboot(2) can result in the filesystem getting IO errors.
> 
> This is somewhat surprising to the users so try improve the behavior by
> switching to errors=remount-ro behavior when the system is running
> reboot(2).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good to me; thanks, applied.

					- Ted
