Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193BACA9EA0
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 01:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE230222C2
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 01:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfJUBIp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 20 Oct 2019 21:08:45 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37751 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726681AbfJUBIp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Oct 2019 21:08:45 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9L18eLY030904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 20 Oct 2019 21:08:40 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E8CAE420458; Sun, 20 Oct 2019 21:08:39 -0400 (EDT)
Date:   Sun, 20 Oct 2019 21:08:39 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 01/22] jbd2: Fix possible overflow in
 jbd2_log_space_left()
Message-ID: <20191021010839.GC6799@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 04, 2019 at 12:05:47AM +0200, Jan Kara wrote:
> When number of free space in the journal is very low, the arithmetic in
> jbd2_log_space_left() could underflow resulting in very high number of
> free blocks and thus triggering assertion failure in transaction commit
> code complaining there's not enough space in the journal:
> 
> J_ASSERT(journal->j_free > 1);
> 
> Properly check for the low number of free blocks.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, you can add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
