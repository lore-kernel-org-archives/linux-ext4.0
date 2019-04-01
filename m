Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE01C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 08:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3575520828
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 08:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfDAIFt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:05:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:46894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfDAIFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 Apr 2019 04:05:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C2C3AE50;
        Mon,  1 Apr 2019 08:05:48 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 3030A1E42C7; Mon,  1 Apr 2019 10:05:48 +0200 (CEST)
Date:   Mon, 1 Apr 2019 10:05:48 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsprogs: Fix autoheader failure
Message-ID: <20190401080548.GB4826@quack2.suse.cz>
References: <20190329165803.8651-1-jack@suse.cz>
 <20190330014857.GC15757@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190330014857.GC15757@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 29-03-19 21:48:57, Theodore Ts'o wrote:
> On Fri, Mar 29, 2019 at 05:58:03PM +0100, Jan Kara wrote:
> > Autoheader reports:
> > 
> > autoheader: warning: missing template: HAVE_BLKID_PROBE_ENABLE_PARTITIONS
> > autoheader: Use AC_DEFINE([HAVE_BLKID_PROBE_ENABLE_PARTITIONS], [], [Description])
> > autoheader: warning: missing template: HAVE_BLKID_PROBE_GET_TOPOLOGY
> > 
> > so provide appropriate descriptions for the defines.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Thanks, apologies for failing to push out the e2fsprogs fix out to git
> earlier, but this problem has already been fixed by commit
> f72ea2deb0d8.

No problem :). I was just packaging latest e2fsprogs release and stumbled
upon this...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
