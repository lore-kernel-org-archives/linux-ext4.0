Return-Path: <SRS0=PW1K=T6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B668AC28CC0
	for <linux-ext4@archiver.kernel.org>; Thu, 30 May 2019 19:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98BC0260A1
	for <linux-ext4@archiver.kernel.org>; Thu, 30 May 2019 19:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfE3TRQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 30 May 2019 15:17:16 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47045 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726031AbfE3TRQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 May 2019 15:17:16 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4UJH0H5015143
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 15:17:02 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id ECC0D420481; Thu, 30 May 2019 15:16:59 -0400 (EDT)
Date:   Thu, 30 May 2019 15:16:59 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Liu Song <fishland@aliyun.com>, jack@suse.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liu.song11@zte.com.cn
Subject: Re: [PATCH] jbd2: fix typo in comment of
 journal_submit_inode_data_buffers
Message-ID: <20190530191659.GH2998@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Liu Song <fishland@aliyun.com>, jack@suse.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        liu.song11@zte.com.cn
References: <20190525091251.3236-1-fishland@aliyun.com>
 <20190527082457.GA20440@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527082457.GA20440@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 27, 2019 at 10:24:57AM +0200, Jan Kara wrote:
> On Sat 25-05-19 17:12:51, Liu Song wrote:
> > From: Liu Song <liu.song11@zte.com.cn>
> > 
> > delayed/dealyed
> > 
> > Signed-off-by: Liu Song <liu.song11@zte.com.cn>
> 
> Thanks. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
