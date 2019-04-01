Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029BBC4360F
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 15:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F8621905
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 15:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfDAPNl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 11:13:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13063 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfDAPNl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 Apr 2019 11:13:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 58973CD66C;
        Mon,  1 Apr 2019 15:13:41 +0000 (UTC)
Received: from work (ovpn-204-116.brq.redhat.com [10.40.204.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 338DB5D706;
        Mon,  1 Apr 2019 15:13:39 +0000 (UTC)
Date:   Mon, 1 Apr 2019 17:13:35 +0200
From:   Lukas Czerner <lczerner@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsprogs: Fix autoheader failure
Message-ID: <20190401151335.fce73kluttm4vcpc@work>
References: <20190329165803.8651-1-jack@suse.cz>
 <20190330014857.GC15757@mit.edu>
 <20190401080548.GB4826@quack2.suse.cz>
 <20190401132412.GB2979@mit.edu>
 <20190401143859.GA17530@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401143859.GA17530@quack2.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 01 Apr 2019 15:13:41 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 01, 2019 at 04:38:59PM +0200, Jan Kara wrote:
> On Mon 01-04-19 09:24:12, Theodore Ts'o wrote:
> > On Mon, Apr 01, 2019 at 10:05:48AM +0200, Jan Kara wrote:
> > > 
> > > No problem :). I was just packaging latest e2fsprogs release and stumbled
> > > upon this...
> > 
> > If you are packaging the e2fsprogs v1.45, I suggest you either (a)
> > hold back on packaging e2scrub, or (b) wait for 1.45.1, which I hope
> > to get out fairly soon, since by packaing 1.45 for Debian unstable,
> > we've gotten many useful bug reports and as you can see, there are a
> > lot of e2scrub fixes that are queued up for the next release.
> 
> Thanks for info! I did package e2scrub but so far disabled installing any
> of crond files, systemd files, or udev rules so it should be harmless
> unless someone manually runs it...

I did pretty much the same thing for rawhide and I do plan to enable the
whole thing with the next update.

Thanks!
-Lukas

> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
