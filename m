Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F0AC43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 16:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05A1A2192D
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 16:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfCWQNs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 23 Mar 2019 12:13:48 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51765 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727482AbfCWQNr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2019 12:13:47 -0400
Received: from callcc.thunk.org ([70.42.157.31])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2NGDZYS028381
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Mar 2019 12:13:38 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id AF928421A01; Sat, 23 Mar 2019 12:13:34 -0400 (EDT)
Date:   Sat, 23 Mar 2019 12:13:34 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: prohibit fstrim in norecovery mode
Message-ID: <20190323161334.GE5675@mit.edu>
References: <20190323003532.GB1180@magnolia>
 <20190323003813.GR1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190323003813.GR1183@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 22, 2019 at 05:38:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The ext4 fstrim implementation uses the block bitmaps to find free space
> that can be discarded.  If we haven't replayed the journal, the bitmaps
> will be stale and we absolutely *cannot* use stale metadata to zap the
> underlying storage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
