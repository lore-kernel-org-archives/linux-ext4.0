Return-Path: <SRS0=Z9Kk=WI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB85C433FF
	for <linux-ext4@archiver.kernel.org>; Mon, 12 Aug 2019 14:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 596F020679
	for <linux-ext4@archiver.kernel.org>; Mon, 12 Aug 2019 14:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfHLOXA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:23:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35208 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726702AbfHLOW7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Aug 2019 10:22:59 -0400
Received: from callcc.thunk.org (guestnat-104-133-9-109.corp.google.com [104.133.9.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x7CEMssF015720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Aug 2019 10:22:56 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 775014218EF; Mon, 12 Aug 2019 10:22:54 -0400 (EDT)
Date:   Mon, 12 Aug 2019 10:22:54 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 01/12] ext4: add handling for extended mount options
Message-ID: <20190812142254.GB11831@mit.edu>
References: <20190809034552.148629-1-harshadshirwadkar@gmail.com>
 <20190809034552.148629-2-harshadshirwadkar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809034552.148629-2-harshadshirwadkar@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Aug 08, 2019 at 08:45:41PM -0700, Harshad Shirwadkar wrote:
> We are running out of mount option bits. This patch adds handling for
> using s_mount_opt2 and also adds ability to turn on / off the fast
> commit feature. In order to use fast commits, new version e2fsprogs
> needs to set the fast feature commit flag. This also makes sure that
> we have fast commit compatible e2fsprogs before starting to use the
> feature. Mount flag "no_fastcommit", introuced in this patch, can be
> passed to disable the feature at mount time.
> 
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

Looks good:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

					- Ted
