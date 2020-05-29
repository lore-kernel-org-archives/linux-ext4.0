Return-Path: <SRS0=2juh=7L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB69EC433E0
	for <linux-ext4@archiver.kernel.org>; Fri, 29 May 2020 03:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD2572075F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 May 2020 03:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391750AbgE2DTd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 May 2020 23:19:33 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:55983 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390172AbgE2DTb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2020 23:19:31 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 04T3JQEd027403
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 May 2020 23:19:26 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 097AE420304; Thu, 28 May 2020 23:19:26 -0400 (EDT)
Date:   Thu, 28 May 2020 23:19:25 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Avoid unnecessary transaction starts during
 writeback
Message-ID: <20200529031925.GL228632@mit.edu>
References: <20200525081215.29451-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525081215.29451-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 25, 2020 at 10:12:15AM +0200, Jan Kara wrote:
> ext4_writepages() currently works in a loop like:
>   start a transaction
>   scan inode for pages to write
>   map and submit these pages
>   stop the transaction
> 
> This loop results in starting transaction once more than is needed
> because in the last iteration we start a transaction only to scan the
> inode and find there are no pages to write. This can be significant
> increase in number of transaction starts for single-extent files or
> files that have all blocks already mapped. Furthermore we already know
> from previous iteration whether there are more pages to write or not. So
> propagate the information from mpage_prepare_extent_to_map() and avoid
> unnecessary looping in case there are no more pages to write.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.  I like how it shrinks the source file.  :-)

		    	     		- Ted
