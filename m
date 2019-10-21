Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E8CCA9EAF
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 17:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5184C2077C
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 17:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfJUReK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Oct 2019 13:34:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:57459 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbfJUReJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2019 13:34:09 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9LHY4pu006615
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 13:34:04 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C88B6420458; Mon, 21 Oct 2019 13:34:03 -0400 (EDT)
Date:   Mon, 21 Oct 2019 13:34:03 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 14/22] jbd2: Drop pointless wakeup from
 jbd2_journal_stop()
Message-ID: <20191021173403.GG27850@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-14-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-14-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 04, 2019 at 12:06:00AM +0200, Jan Kara wrote:
> When we drop last handle from a transaction and journal->j_barrier_count
> > 0, jbd2_journal_stop() wakes up journal->j_wait_transaction_locked
> wait queue. This looks pointless - wait for outstanding handles always
> happens on journal->j_wait_updates waitqueue.
> journal->j_wait_transaction_locked is used to wait for transaction state
> changes and by start_this_handle() for waiting until
> journal->j_barrier_count drops to 0. The first case is clearly
> irrelevant here since only jbd2 thread changes transaction state. The
> second case looks related but jbd2_journal_unlock_updates() is
> responsible for the wakeup in this case. So just drop the wakeup.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good; feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
