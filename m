Return-Path: <SRS0=+gwK=S7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136B8C43218
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Apr 2019 00:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDC8320675
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Apr 2019 00:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfD2Ag7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 20:36:59 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51909 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726223AbfD2Ag7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2019 20:36:59 -0400
Received: from callcc.thunk.org (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3T0aquZ022129
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Apr 2019 20:36:53 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B56C9420023; Sun, 28 Apr 2019 20:36:51 -0400 (EDT)
Date:   Sun, 28 Apr 2019 20:36:51 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH] libext2fs: remove unused variable 'buff'
Message-ID: <20190429003651.GF3789@mit.edu>
References: <20190422210843.185382-1-ebiggers@kernel.org>
 <85sgu9s6us.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85sgu9s6us.fsf@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 23, 2019 at 12:06:35AM -0400, Gabriel Krisman Bertazi wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
> 
> > From: Eric Biggers <ebiggers@google.com>
> >
> > In ext2fs_dirhash2(), the outer 'buff' variable is never used.
> >
> > Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks, applied.

					- Ted
