Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEC7C433F5
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Jan 2022 04:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352409AbiA2Eyd (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 28 Jan 2022 23:54:33 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35907 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1352399AbiA2Eyd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Jan 2022 23:54:33 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 20T4sQgQ003035
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jan 2022 23:54:26 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id DB3D715C0040; Fri, 28 Jan 2022 23:54:25 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-ext4@vger.kernel.org,
        hongnanli <hongnan.li@linux.alibaba.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca
Subject: Re: [PATCH] fs/ext4: fix comments mentioning i_mutex
Date:   Fri, 28 Jan 2022 23:54:24 -0500
Message-Id: <164343205445.816880.17095433748908278662.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220121070611.21618-1-hongnan.li@linux.alibaba.com>
References: <20220121070611.21618-1-hongnan.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, 21 Jan 2022 15:06:11 +0800, hongnanli wrote:
> inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
> comments still mentioning i_mutex.
> 
> 

Applied, thanks!

[1/1] fs/ext4: fix comments mentioning i_mutex
      commit: b36c9466ce982906a6420e6af0fca73d1c0931b5

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
