Return-Path: <SRS0=Ptqg=YQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1B8CA9EB9
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Oct 2019 19:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4CE02086D
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Oct 2019 19:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbfJWTqL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Oct 2019 15:46:11 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36281 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728697AbfJWTqL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Oct 2019 15:46:11 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9NJk5na030394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Oct 2019 15:46:06 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3F07F420456; Wed, 23 Oct 2019 15:46:05 -0400 (EDT)
Date:   Wed, 23 Oct 2019 15:46:05 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix signed vs unsigned comparison in
 ext4_valid_extent()
Message-ID: <20191023194605.GA7630@mit.edu>
References: <20191023013112.18809-1-tytso@mit.edu>
 <20191023054447.GE361298@sol.localdomain>
 <20191023131546.GB2460@mit.edu>
 <20191023184332.GC7689@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023184332.GC7689@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Oct 23, 2019 at 11:43:33AM -0700, Ira Weiny wrote:
> On Wed, Oct 23, 2019 at 09:15:46AM -0400, Theodore Y. Ts'o wrote:
> > On Tue, Oct 22, 2019 at 10:44:47PM -0700, Eric Biggers wrote:
> > > 
> > > This patch can't be fixing anything because the comparison is unsigned both
> > > before and after this patch.
> > 
> > Thanks, you're right; I had forgotten C's signed/unsigned rules for
> > addition.  The funny thing is the original reporter of BZ #205197
> > reported that the problem went away he tried a similar patch.
> 
> Not trying to stick my nose in too much here but:
> 
> What does it mean if ext4_ext_get_actual_len() to return < 0?

It's not possible for it to return < 0.  We probably should clean it
up to make it return an unsigned int, but that's a longer-term clean-up.

      	      	     		 - Ted
