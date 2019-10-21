Return-Path: <SRS0=b1z3=YO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4BFCA9EAF
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 16:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A621205C9
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Oct 2019 16:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfJUQV0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:21:26 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35787 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726289AbfJUQV0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Oct 2019 12:21:26 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x9LGLLcV005578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 12:21:21 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F1D1A420458; Mon, 21 Oct 2019 12:21:20 -0400 (EDT)
Date:   Mon, 21 Oct 2019 12:21:20 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 09/22] ext4, jbd2: Provide accessor function for handle
 credits
Message-ID: <20191021162120.GB27850@mit.edu>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-9-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003220613.10791-9-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Oct 04, 2019 at 12:05:55AM +0200, Jan Kara wrote:
> Provide accessor function to get number of credits available in a handle
> and use it from ext4. Later, computation of available credits won't be
> so straightforward.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, you can add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

