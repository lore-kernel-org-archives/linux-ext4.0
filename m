Return-Path: <SRS0=G6ZV=DQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB1FC433DF
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Oct 2020 02:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6115F20725
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Oct 2020 02:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgJICSy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 8 Oct 2020 22:18:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47836 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729724AbgJICSx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2020 22:18:53 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0992Gqv6007587
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 8 Oct 2020 22:16:52 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 09E0F420107; Thu,  8 Oct 2020 22:16:52 -0400 (EDT)
Date:   Thu, 8 Oct 2020 22:16:51 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Fengnan Chang <changfengnan@hikvision.com>,
        changfengnan <fengnanchang@foxmail.com>
Subject: Re: [PATCH v4] jbd2: avoid transaction reuse after reformatting
Message-ID: <20201009021651.GI235506@mit.edu>
References: <20201007081319.16341-1-jack@suse.cz>
 <AF239FDD-1550-4D24-B2A4-C015689C9203@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF239FDD-1550-4D24-B2A4-C015689C9203@dilger.ca>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Oct 08, 2020 at 02:13:02PM -0600, Andreas Dilger wrote:
> On Oct 7, 2020, at 2:13 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > From: changfengnan <fengnanchang@foxmail.com>
> > 
> > When ext4 is formatted with lazy_journal_init=1 and transactions from
> > the previous filesystem are still on disk, it is possible that they are
> > considered during a recovery after a crash. Because the checksum seed
> > has changed, the CRC check will fail, and the journal recovery fails
> > with checksum error although the journal is otherwise perfectly valid.
> > Fix the problem by checking commit block time stamps to determine
> > whether the data in the journal block is just stale or whether it is
> > indeed corrupt.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Fengnan Chang <changfengnan@hikvision.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 
> NB: one trivial formatting cleanup if patch is refreshed
>

Applied, thanks.  I fixed the trivial format cleanup you pointed out,
plus a whitespace fix pointed out by checkpatch.

       		      	      	     - Ted
