Return-Path: <SRS0=IuoM=TY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D8CC072B5
	for <linux-ext4@archiver.kernel.org>; Fri, 24 May 2019 04:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D83152133D
	for <linux-ext4@archiver.kernel.org>; Fri, 24 May 2019 04:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfEXE1t (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 May 2019 00:27:49 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39909 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725710AbfEXE1t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 May 2019 00:27:49 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4O4RdK0029483
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 May 2019 00:27:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8C8A9420481; Fri, 24 May 2019 00:27:39 -0400 (EDT)
Date:   Fri, 24 May 2019 00:27:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Chengguang Xu <cgxu519@zoho.com.cn>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove some redundant corruption checks
Message-ID: <20190524042739.GE2532@mit.edu>
References: <20190523124843.566-1-cgxu519@zoho.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523124843.566-1-cgxu519@zoho.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 23, 2019 at 08:48:43PM +0800, Chengguang Xu wrote:
> Remove some redundant corruption checks in
> ext4_xattr_block_get() and ext4_xattr_ibody_get()
> because ext4_xattr_check_entries() has done those
> checks.
> 
> Signed-off-by: Chengguang Xu <cgxu519@zoho.com.cn>

I deliberately left in the redundant checks.

That's because we still have issues where a buffer can be verified for
some other block type (say, an allocation bitmap), but if that block
is also referenced as an xattr block, we could cause a kernel crash,
or worse, we might be end up corrupting kernel memory in some way that
would lead to a privilege escalation test.

I would actually prefer that we have enough tests ant the Time Of Use
that we wouldn't need to check the whole xattr block the first time we
read it into memory.  The way we are doing it today, we are very much
vulnerable to TOC/TOU bugs/vulnerabilities.

In the long run we should making the xattr code so careful and robust
that we wouldn't need to use the ext4_xattr_check_entries() except as
a backup safety.  (Today, we depend on it far too much, and there have
been multiple example of deliberately/malicious crafted file systems
which can bypass the checks in ext4_xattr_check_entries() check.  Just
scan fs/ext4/xattr.c for various CVE fixes....)  So if anything we
should be adding more checks to ext4_xattr_block_get(), et. al.

					- Ted
