Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043F9C433F5
	for <linux-ext4@archiver.kernel.org>; Sun, 13 Mar 2022 04:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbiCMErO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 12 Mar 2022 23:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiCMErH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Mar 2022 23:47:07 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C78B162014;
        Sat, 12 Mar 2022 20:46:00 -0800 (PST)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22D4jkvF009263
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Mar 2022 23:45:48 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 028A515C3E98; Sat, 12 Mar 2022 23:45:46 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     linux-doc@vger.kernel.org,
        lianzhi chang <changlianzhi@uniontech.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH] doc: Fixed a bug in ext4 document
Date:   Sat, 12 Mar 2022 23:45:38 -0500
Message-Id: <164714672856.1260831.12676866364152396817.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220310014415.29937-1-changlianzhi@uniontech.com>
References: <20220310014415.29937-1-changlianzhi@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, 10 Mar 2022 09:44:15 +0800, lianzhi chang wrote:
> The unit of file system size should be TiB, not PiB
> 
> 

Applied, thanks!

[1/1] doc: Fixed a bug in ext4 document
      commit: 688b0d8536e0e937f608a93cb6909e14389a0c45

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
