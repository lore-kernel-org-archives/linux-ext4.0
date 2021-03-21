Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901E6C433C1
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Mar 2021 04:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D6D06193B
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Mar 2021 04:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCUEoN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Mar 2021 00:44:13 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45632 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229870AbhCUEnx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Mar 2021 00:43:53 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12L4hiJR017790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 00:43:45 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 6DBC115C39CA; Sun, 21 Mar 2021 00:43:44 -0400 (EDT)
Date:   Sun, 21 Mar 2021 00:43:44 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Pan Bian <bianpan2016@163.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ext4: stop inode update before return
Message-ID: <YFbPADCUjfgL37Pz@mit.edu>
References: <20210117085732.93788-1-bianpan2016@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210117085732.93788-1-bianpan2016@163.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jan 17, 2021 at 12:57:32AM -0800, Pan Bian wrote:
> The inode update should be stopped before returing the error code.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Thanks, applied.

					- Ted
