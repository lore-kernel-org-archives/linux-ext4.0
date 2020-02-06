Return-Path: <SRS0=cg8q=32=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAFEC2D0B1
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Feb 2020 10:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0757B20658
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Feb 2020 10:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgBFKRB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Feb 2020 05:17:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:46462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgBFKRB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Feb 2020 05:17:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DBECBB0E6;
        Thu,  6 Feb 2020 10:16:59 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id ACAA31E0E31; Thu,  6 Feb 2020 11:16:59 +0100 (CET)
Date:   Thu, 6 Feb 2020 11:16:59 +0100
From:   Jan Kara <jack@suse.cz>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] tests: Add tests for ext2fs_link() into htree dir
Message-ID: <20200206101659.GJ14001@quack2.suse.cz>
References: <20200205100138.30053-1-jack@suse.cz>
 <20200205100138.30053-4-jack@suse.cz>
 <E9A04E5E-96E0-48FC-AC41-FCA8193E058E@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E9A04E5E-96E0-48FC-AC41-FCA8193E058E@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 05-02-20 11:11:13, Andreas Dilger wrote:
> On Feb 5, 2020, at 3:01 AM, Jan Kara <jack@suse.cz> wrote:
> > 
> > Add two tests adding 50000 files into a htree directory to test various
> > cases of htree modification.
> 
> Note that there is already tests/f_large_dir that is creating a large
> directory via debugfs.  Maybe that could be extended rather than adding
> another long-running test to do almost the same thing?

I didn't know tests/f_large_dir exists. Thanks for the pointer. There are
just two problems with this:

1) I wanted to test both with & without metadata_csum because the code
paths are somewhat different.

2) Currently we don't have implemented conversion of normal dir into
indexed one so I need to start with a fs image that already has indexed
directory.

I suppose I could modify tests/f_large_dir to start with an image to
address 2) if people are OK with that. And I could just create
tests/f_large_dir_csum to address 1).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
