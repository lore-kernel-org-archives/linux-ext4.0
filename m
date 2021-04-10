Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330B5C433ED
	for <linux-ext4@archiver.kernel.org>; Sat, 10 Apr 2021 03:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2385611C1
	for <linux-ext4@archiver.kernel.org>; Sat, 10 Apr 2021 03:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhDJDZm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 9 Apr 2021 23:25:42 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60550 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229665AbhDJDZl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Apr 2021 23:25:41 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13A3PBZd012339
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 9 Apr 2021 23:25:11 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0341215C3B12; Fri,  9 Apr 2021 23:25:10 -0400 (EDT)
Date:   Fri, 9 Apr 2021 23:25:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     riteshh <riteshh@linux.ibm.com>
Cc:     Jack Qiu <jack.qiu@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH -next] ext4: fix trailing whitespace
Message-ID: <YHEalkT4Pjeak3ol@mit.edu>
References: <20210409042035.15516-1-jack.qiu@huawei.com>
 <20210409045023.bcxnxfbnwyshoewv@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409045023.bcxnxfbnwyshoewv@riteshh-domain>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Apr 09, 2021 at 10:20:23AM +0530, riteshh wrote:
> On 21/04/09 12:20PM, Jack Qiu wrote:
> > Made suggested modifications from checkpatch in reference to ERROR:
> >  trailing whitespace
> 
> Also happens to be useful to folks who have auto remove of any whitespace
> at end of line on file save in their editor setup ;)
> 
> " for vim
> autocmd BufWritePre * %s/\s\+$//e
> 
> So, patch looks good to me.
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>

Applied, thanks.

					- Ted
