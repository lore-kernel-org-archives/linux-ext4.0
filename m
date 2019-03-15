Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB41C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7FA5206BA
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 03:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfCODwi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:52:38 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33785 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726812AbfCODwi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 23:52:38 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2F3qSLr027205
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Mar 2019 23:52:29 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 29101420AA8; Thu, 14 Mar 2019 23:52:28 -0400 (EDT)
Date:   Thu, 14 Mar 2019 23:52:28 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jason Yan <yanaijie@huawei.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove useless ext4_pin_inode()
Message-ID: <20190315035228.GE11334@mit.edu>
References: <20190227022048.22887-1-yanaijie@huawei.com>
 <8ea5a72f-d339-450c-2604-49f730afa43b@huawei.com>
 <50BB10C6-BE07-4BF7-9399-BD7A32EB3A54@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BB10C6-BE07-4BF7-9399-BD7A32EB3A54@dilger.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thanks, applied.

					- Ted
