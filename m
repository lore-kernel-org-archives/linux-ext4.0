Return-Path: <SRS0=ue5q=TV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8947BC04AAF
	for <linux-ext4@archiver.kernel.org>; Tue, 21 May 2019 03:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69B512075E
	for <linux-ext4@archiver.kernel.org>; Tue, 21 May 2019 03:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfEUD34 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 20 May 2019 23:29:56 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60343 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726511AbfEUD34 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 May 2019 23:29:56 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4L3TZTB032052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 May 2019 23:29:35 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C8793420481; Mon, 20 May 2019 23:29:34 -0400 (EDT)
Date:   Mon, 20 May 2019 23:29:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [PATCH v6 00/16] fscrypt: key management improvements
Message-ID: <20190521032934.GA14876@mit.edu>
References: <20190520172552.217253-1-ebiggers@kernel.org>
 <20190521001636.GA2369@mit.edu>
 <20190521004119.GA647@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521004119.GA647@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 20, 2019 at 05:41:20PM -0700, Eric Biggers wrote:
> 
> This was answered in the cover letter, quoted below:

Oops, thanks.  My bad, I stopped reading when I saw the changelog, and
missed that part of the description.

					- Ted
