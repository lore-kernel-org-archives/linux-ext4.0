Return-Path: <SRS0=4/Wo=UB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED02C28CC5
	for <linux-ext4@archiver.kernel.org>; Sun,  2 Jun 2019 00:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72A92776C
	for <linux-ext4@archiver.kernel.org>; Sun,  2 Jun 2019 00:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfFBAPV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 1 Jun 2019 20:15:21 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50993 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbfFBAPU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Jun 2019 20:15:20 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x520FFpP024883
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 1 Jun 2019 20:15:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 972BA420481; Sat,  1 Jun 2019 20:15:15 -0400 (EDT)
Date:   Sat, 1 Jun 2019 20:15:15 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove unnecessary gotos in ext4_xattr_set_entry
Message-ID: <20190602001515.GB15741@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20190531121016.11727-1-ptikhomirov@virtuozzo.com>
 <01FB1966-0466-4AB2-913B-F53E8CA816BE@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01FB1966-0466-4AB2-913B-F53E8CA816BE@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, May 31, 2019 at 03:46:54PM -0600, Andreas Dilger wrote:
> On May 31, 2019, at 6:10 AM, Pavel Tikhomirov <ptikhomirov@virtuozzo.com> wrote:
> > 
> > In the "out" label we only iput old/new_ea_inode-s, in all these places
> > these variables are always NULL so there is no point in goto to "out".
> > 
> > Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> 
> I'm not a fan of changes like this, since it adds potential complexity/bugs
> if the error handling path is changed in the future.  That is one of the major
> benefits of the "goto out_*" model of error handling is that you only need to
> add one new label to the end of the function when some new state is added that
> needs to be cleaned up, compared to having to check each individual error to
> see if something needs to be cleaned up.

I'm not a fan either, for the reasons Andreas stated; if you ever move
code around, it's much more hazardous because you now have to check if
what had previously been a "return ret" now has to change into "goto
outl".  In some case, it's really obvious, if the code is at the very
beginning of the function, but when you're 35 lines down, well over
the size of many of an editor window, it's no longer quite so obvious
whether or not "goto out" is necessary.

						- Ted
