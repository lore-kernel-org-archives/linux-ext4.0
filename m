Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E90EC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2431B21873
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfCODMl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:12:41 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55991 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727284AbfCODMl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 23:12:41 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F3CZEu018298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Mar 2019 23:12:35 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0563B420AA8; Thu, 14 Mar 2019 23:12:34 -0400 (EDT)
Date:   Thu, 14 Mar 2019 23:12:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Dongyang Li <dongyangli@ddn.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] e2fsprogs: fix autoheader warnings
Message-ID: <20190315031234.GA11334@mit.edu>
References: <20190306225944.12993-1-dongyangli@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190306225944.12993-1-dongyangli@ddn.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 06, 2019 at 10:59:55PM +0000, Dongyang Li wrote:
> autoheader complains after 1.44.6 release:
> autoheader: warning: missing template: HAVE_BLKID_PROBE_ENABLE_PARTITIONS
> autoheader: Use AC_DEFINE([HAVE_BLKID_PROBE_ENABLE_PARTITIONS], [], [Description])
> autoheader: warning: missing template: HAVE_BLKID_PROBE_GET_TOPOLOGY
> 
> This could fail automatic rpm builds.
> Fixes: 7154d97 ("Check for the newer blkid functions without adding blkid to @LIBS@")
> 
> Signed-off-by: Li Dongyang <dongyangli@ddn.com>

Thanks, applied.

					- Ted
