Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E01CC43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 14:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79488206B6
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 14:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfDAOjD (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 10:39:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:44722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbfDAOjC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 Apr 2019 10:39:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2505AFA7;
        Mon,  1 Apr 2019 14:39:01 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 950B01E42C7; Mon,  1 Apr 2019 16:38:59 +0200 (CEST)
Date:   Mon, 1 Apr 2019 16:38:59 +0200
From:   Jan Kara <jack@suse.cz>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsprogs: Fix autoheader failure
Message-ID: <20190401143859.GA17530@quack2.suse.cz>
References: <20190329165803.8651-1-jack@suse.cz>
 <20190330014857.GC15757@mit.edu>
 <20190401080548.GB4826@quack2.suse.cz>
 <20190401132412.GB2979@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401132412.GB2979@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 01-04-19 09:24:12, Theodore Ts'o wrote:
> On Mon, Apr 01, 2019 at 10:05:48AM +0200, Jan Kara wrote:
> > 
> > No problem :). I was just packaging latest e2fsprogs release and stumbled
> > upon this...
> 
> If you are packaging the e2fsprogs v1.45, I suggest you either (a)
> hold back on packaging e2scrub, or (b) wait for 1.45.1, which I hope
> to get out fairly soon, since by packaing 1.45 for Debian unstable,
> we've gotten many useful bug reports and as you can see, there are a
> lot of e2scrub fixes that are queued up for the next release.

Thanks for info! I did package e2scrub but so far disabled installing any
of crond files, systemd files, or udev rules so it should be harmless
unless someone manually runs it...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
