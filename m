Return-Path: <SRS0=u900=WU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D313FC3A5A2
	for <linux-ext4@archiver.kernel.org>; Sat, 24 Aug 2019 00:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1D8621726
	for <linux-ext4@archiver.kernel.org>; Sat, 24 Aug 2019 00:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbfHXARe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 23 Aug 2019 20:17:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52326 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725807AbfHXARe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Aug 2019 20:17:34 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x7O0HSAv017564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Aug 2019 20:17:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9B7B042049E; Fri, 23 Aug 2019 20:17:28 -0400 (EDT)
Date:   Fri, 23 Aug 2019 20:17:28 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: rework reserved cluster accounting when
 invalidating pages
Message-ID: <20190824001728.GA19348@mit.edu>
References: <20190817193103.28912-1-enwlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817193103.28912-1-enwlinux@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Aug 17, 2019 at 03:31:03PM -0400, Eric Whitney wrote:
> The goal of this patch is to remove two references to the buffer delay
> bit in ext4_da_page_release_reservation() as part of a larger effort
> to remove all such references from ext4.  These two references are
> principally used to reduce the reserved block/cluster count when pages
> are invalidated as a result of truncating, punching holes, or
> collapsing a block range in a file.  The entire function is removed
> and replaced with code in ext4_es_remove_extent() that reduces the
> reserved count as a side effect of removing a block range from delayed
> and not unwritten extents in the extent status tree as is done when
> truncating, punching holes, or collapsing ranges.
> 
> The code is written to minimize the number of searches descending from
> rb tree roots for scalability.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Thanks, applied.

					- Ted
