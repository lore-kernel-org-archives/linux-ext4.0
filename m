Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3898ECA9EAF
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 16:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079A12084B
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 16:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfJUQYV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:24:21 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36517 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726289AbfJUQYV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2019 12:24:21 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9LGOFWs006589
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 12:24:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 64BC0420458; Mon, 21 Oct 2019 12:24:15 -0400 (EDT)
Date:   Mon, 21 Oct 2019 12:24:15 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 11/22] jbd2: Fix statistics for the number of logged
 blocks
Message-ID: <20191021162415.GD27850@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-11-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-11-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 04, 2019 at 12:05:57AM +0200, Jan Kara wrote:
> jbd2 statistics counting number of blocks logged in a transaction was
> wrong. It didn't count the commit block and more importantly it didn't
> count revoke descriptor blocks. Make sure these get properly counted.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, you can add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Thanks,

					- Ted
