Return-Path: <SRS0=QItb=SB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73B8C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 01:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B47FD2183F
	for <linux-ext4@archiver.kernel.org>; Sat, 30 Mar 2019 01:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfC3BtF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:49:05 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41549 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729857AbfC3BtE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2019 21:49:04 -0400
Received: from callcc.thunk.org (96-72-102-169-static.hfc.comcastbusiness.net [96.72.102.169] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2U1mwrH031229
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Mar 2019 21:48:59 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A6B83421A03; Fri, 29 Mar 2019 21:48:57 -0400 (EDT)
Date:   Fri, 29 Mar 2019 21:48:57 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsprogs: Fix autoheader failure
Message-ID: <20190330014857.GC15757@mit.edu>
References: <20190329165803.8651-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329165803.8651-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 29, 2019 at 05:58:03PM +0100, Jan Kara wrote:
> Autoheader reports:
> 
> autoheader: warning: missing template: HAVE_BLKID_PROBE_ENABLE_PARTITIONS
> autoheader: Use AC_DEFINE([HAVE_BLKID_PROBE_ENABLE_PARTITIONS], [], [Description])
> autoheader: warning: missing template: HAVE_BLKID_PROBE_GET_TOPOLOGY
> 
> so provide appropriate descriptions for the defines.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, apologies for failing to push out the e2fsprogs fix out to git
earlier, but this problem has already been fixed by commit
f72ea2deb0d8.

Cheers,

					- Ted
