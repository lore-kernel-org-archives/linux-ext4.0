Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166A3C433DB
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Mar 2021 15:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99E76198E
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Mar 2021 15:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCVPMn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:12:43 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56342 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231409AbhCVPMa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2021 11:12:30 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12MFC6gY006691
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 11:12:07 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0B6B415C39CC; Mon, 22 Mar 2021 11:12:06 -0400 (EDT)
Date:   Mon, 22 Mar 2021 11:12:05 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     yi.zhang@huawei.com, torvalds@linux-foundation.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes for v5.12
Message-ID: <YFizxSL2PKrIdyzy@mit.edu>
References: <YFgIZe4vMRDm+g8u@mit.edu>
 <20210322121052.GA17398@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210322121052.GA17398@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 22, 2021 at 11:10:52PM +1100, Herbert Xu wrote:
> Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> > From: 曹子德(Theodore Y Ts'o) <tytso@mit.edu>
> 
> "Yue" doesn't seem to match your second character which is usually
> romanised as "Tze" in Cantonese, could it be
> 
> 	曹予德

Quite right.  I hadn't noticed that I had the wrong character when I
cut and pasted.  Thanks for pointing that out!

    		 	    	     - Ted
