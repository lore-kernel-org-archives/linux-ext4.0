Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F23C282DD
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 18:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDBF120880
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 18:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfDGS0j (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 14:26:39 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44662 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726362AbfDGS0j (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 14:26:39 -0400
Received: from callcc.thunk.org (177.sub-174-222-154.myvzw.com [174.222.154.177])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x37IQPcg012621
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 7 Apr 2019 14:26:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F166C421A0D; Sun,  7 Apr 2019 12:52:06 -0400 (EDT)
Date:   Sun, 7 Apr 2019 12:52:06 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2] Updated locking documentation for transaction_t
Message-ID: <20190407165206.GA11370@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        Alexander Lochmann <alexander.lochmann@tu-dortmund.de>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318184237.20677-1-alexander.lochmann@tu-dortmund.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 07:42:37PM +0100, Alexander Lochmann wrote:
>  	/*t
> -	 * Where in the log does this transaction's commit start? [no locking]
> +	 * Where in the log does this transaction's commit start?
> +	 * [journal_t.j_state_lock]
>  	 */
>  	unsigned long		t_log_start;

Well, technically, that's not quite right.  It's only assigned in one
location, and we hold j_state_lock, yes.  But that's because we need
to access journal->j_head.  At the point where we set t_log_start, the
transaction has already been locked down (transaction->t_state >
T_LOCKED).

Similarly, we happen to be holding j_state where it is currently being
accessed, but it's not because we needed the lock in order to access
t_log_start safely.

>  	/*
> -	 * When transaction started
> +	 * When transaction started [journal_t.j_state_lock]
>  	 */
>  	unsigned long		t_start;

And again, not really.  The primary place where t_start is set is when
the transaction is firstt created, before it's visible anywhere else.
after that, it is used exclusively by the commit thread, and so no
locking is necessary.  It's true that in the places where it is used,
j_state_lock happens to be taken, but it's strictly not necessary.

>  
>  	/*
> -	 * When commit was requested
> +	 * When commit was requested [journal_t.j_state_lock]
>  	 */
>  	unsigned long		t_requested;

Yes, that appears to be correct.

>  
>  	/*
> -	 * Checkpointing stats [j_checkpoint_sem]
> +	 * Checkpointing stats [journal_t.j_list_lock]
>  	 */
>  	struct transaction_chp_stats_s t_chp_stats;
>

This appears to be correct.

						- Ted
