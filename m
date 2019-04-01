Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1366BC4360F
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 13:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DECAE20870
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 13:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfDANYS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 09:24:18 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37810 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726473AbfDANYS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2019 09:24:18 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x31DODw3025770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 1 Apr 2019 09:24:13 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E8BC0421A03; Mon,  1 Apr 2019 09:24:12 -0400 (EDT)
Date:   Mon, 1 Apr 2019 09:24:12 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] e2fsprogs: Fix autoheader failure
Message-ID: <20190401132412.GB2979@mit.edu>
References: <20190329165803.8651-1-jack@suse.cz>
 <20190330014857.GC15757@mit.edu>
 <20190401080548.GB4826@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401080548.GB4826@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 01, 2019 at 10:05:48AM +0200, Jan Kara wrote:
> 
> No problem :). I was just packaging latest e2fsprogs release and stumbled
> upon this...

If you are packaging the e2fsprogs v1.45, I suggest you either (a)
hold back on packaging e2scrub, or (b) wait for 1.45.1, which I hope
to get out fairly soon, since by packaing 1.45 for Debian unstable,
we've gotten many useful bug reports and as you can see, there are a
lot of e2scrub fixes that are queued up for the next release.

       	       	     	      	     - Ted
