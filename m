Return-Path: <SRS0=o0xn=S6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE088C43218
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 19:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84EB62067C
	for <linux-ext4@archiver.kernel.org>; Sun, 28 Apr 2019 19:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfD1TMm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 28 Apr 2019 15:12:42 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47646 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726418AbfD1TMm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Apr 2019 15:12:42 -0400
Received: from callcc.thunk.org (75-104-85-194.mobility.exede.net [75.104.85.194] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3SJCUvq004170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 28 Apr 2019 15:12:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id B589B420023; Sun, 28 Apr 2019 15:12:29 -0400 (EDT)
Date:   Sun, 28 Apr 2019 15:12:29 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 05/10] ext2fs: nls: Merge sparse fixes from the
 kernel version
Message-ID: <20190428191229.GJ24089@mit.edu>
References: <20190413054317.7388-1-krisman@collabora.com>
 <20190413054317.7388-6-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413054317.7388-6-krisman@collabora.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Apr 13, 2019 at 01:43:12AM -0400, Gabriel Krisman Bertazi wrote:
> The sparse script complained about the following issues in the kernel
> version of this script.  This patch port the fixes to the userspace
> version.
> 
> sparse warnings: (new ones prefixed by >>)
> 
> >> fs/unicode/utf8-norm.c:41:24: sparse: non-ANSI function declaration
>    of function 'utf8version_latest'
> 
> vim +/utf8version_latest +41 fs/unicode/utf8-norm.c
> 
>   40
> > 41	int utf8version_latest()
>   42	{
>   43		return utf8vers;
>   44		}
>   45	EXPORT_SYMBOL(utf8version_latest);
>   46
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

Thanks, applied.

						- Ted
