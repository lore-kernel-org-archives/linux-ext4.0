Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9249CA9EAF
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 22:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 845102086D
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 22:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfJUWaG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Oct 2019 18:30:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49419 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727264AbfJUWaF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2019 18:30:05 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9LMTxP0012732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 18:30:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 69DE1420456; Mon, 21 Oct 2019 18:29:59 -0400 (EDT)
Date:   Mon, 21 Oct 2019 18:29:59 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 20/22] jbd2: Make credit checking more strict
Message-ID: <20191021222959.GE24015@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-20-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-20-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 04, 2019 at 12:06:06AM +0200, Jan Kara wrote:
> Make checking of available credits in jbd2_journal_dirty_metadata() more
> strict. There should be always enough credits in the handle to write all
> potential revoke descriptors. Also we warn in case there are not enough
> credits since this is a bug in the filesystem.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This is fine, but I wonder if we should also be returning an error in
jbd2_journal_revoke() --- of course, one problem is ext4_forget() is
getting called from ext4_free_blocks(), which currently doesn't return
an error.  But we can capture the error return in __ext4_forget(), and
at that point we can give a much more useful error message, since we
can print the function caller and line number.

Feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

