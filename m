Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E35C433B4
	for <linux-ext4@archiver.kernel.org>; Thu, 13 May 2021 14:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC3F86143B
	for <linux-ext4@archiver.kernel.org>; Thu, 13 May 2021 14:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhEMORN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 May 2021 10:17:13 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44976 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234249AbhEMORK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 May 2021 10:17:10 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 14DEFVOa009307
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 May 2021 10:15:32 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9B67515C3B1D; Thu, 13 May 2021 10:15:31 -0400 (EDT)
Date:   Thu, 13 May 2021 10:15:31 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Changheun Lee <nanich.lee@samsung.com>
Cc:     alex_y_xu@yahoo.ca, axboe@kernel.dk, bgoncalv@redhat.com,
        bvanassche@acm.org, dm-crypt@saout.de, hch@lst.de,
        jaegeuk@kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, ming.lei@redhat.com,
        yi.zhang@redhat.com
Subject: Re: regression: data corruption with ext4 on LUKS on nvme with
 torvalds master
Message-ID: <YJ00g8oBZkduQXIe@mit.edu>
References: <CGME20210513100034epcas1p4b23892cd77bde73c777eea6dc51c16a4@epcas1p4.samsung.com>
 <20210513094222.17635-1-nanich.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513094222.17635-1-nanich.lee@samsung.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, May 13, 2021 at 06:42:22PM +0900, Changheun Lee wrote:
> 
> Problem might be casued by exhausting of memory. And memory exhausting
> would be caused by setting of small bio_max_size. Actually it was not
> reproduced in my VM environment at first. But, I reproduced same problem
> when bio_max_size is set with 8KB forced. Too many bio allocation would
> be occurred by setting of 8KB bio_max_size.

Hmm... I'm not sure how to align your diagnosis with the symptoms in
the bug report.  If we were limited by memory, that should slow down
the I/O, but we should still be making forward progress, no?  And a
forced reboot should not result in data corruption, unless maybe there
was a missing check for a failed memory allocation, causing data to be
written to the wrong location, a missing error check leading to the
block or file system layer not noticing that a write had failed
(although again, memory exhaustion should not lead to failed writes;
it might slow us down, sure, but if writes are being failed, something
is Badly Going Wrong --- things like writes to the swap device or
writes by the page cleaner must succeed, or else Things Would Go Bad
In A Hurry).

						- Ted
