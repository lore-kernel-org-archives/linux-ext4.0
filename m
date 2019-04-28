Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD09C43219
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 20:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 934D5206A3
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 20:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfD1Us5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 16:48:57 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38061 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725982AbfD1Us5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2019 16:48:57 -0400
Received: from callcc.thunk.org (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3SKmpD5028668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Apr 2019 16:48:53 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 49B2F420023; Sun, 28 Apr 2019 16:48:51 -0400 (EDT)
Date:   Sun, 28 Apr 2019 16:48:51 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 08/10] ext2fs: nls: Drop normalization code
Message-ID: <20190428204851.GC3789@mit.edu>
References: <20190413054317.7388-1-krisman@collabora.com>
 <20190413054317.7388-9-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413054317.7388-9-krisman@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Apr 13, 2019 at 01:43:15AM -0400, Gabriel Krisman Bertazi wrote:
> No longer necessary after +F design change.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks, applied.

						- Ted
