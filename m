Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75117C433FE
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Nov 2022 21:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiK2VMx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbiK2VMe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Nov 2022 16:12:34 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E7D2D1;
        Tue, 29 Nov 2022 13:12:25 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2ATLCKWu029748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 16:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1669756341; bh=6vpCMz8Fq7hsn/elvmb2vPvNdMZzxegtck4rLPQptoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NWx5r0WxDW81Uowl9oS/AAkHIDY0jFXDo92O38wHtK6aLEGkVvcYP4z9RieH+pK8H
         0Rbeg+fQgADb2jYna+1FlX9jKErCkpA+5IGTqQ5uzmxFDfUGYnQ4izR8EhJxjMziX/
         DoSKUVpSBQheV+vS3gPGVwe/Uao5TzhLeuoEe+lClQQHZWEenmYR9dCQHZQcjLnK5i
         V4LanLQCrJtAC4DmamKhm3bHk8Ysd9Ol976YZ3hmnVKLRCHzHGEUYS5pO62SCc7CIP
         7IBcOrOm/1smzApy5ADp5L3P9hAXlJcTupKGWYFNwJNXJU7eNikh/fn+Xo9SKm8q9x
         Irluay2/GXkIQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 69BEB15C3AC9; Tue, 29 Nov 2022 16:12:19 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger.kernel@dilger.ca>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: remove trailing newline from ext4_msg() message
Date:   Tue, 29 Nov 2022 16:12:13 -0500
Message-Id: <166975630696.2135297.5594335523884250763.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20221011155758.15287-1-lhenriques@suse.de>
References: <20221011155758.15287-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 11 Oct 2022 16:57:58 +0100, Luís Henriques wrote:
> The ext4_msg() function adds a new line to the message.  Remove extra '\n'
> from call to ext4_msg() in ext4_orphan_cleanup().
> 
> 

Applied, thanks!

[1/1] ext4: remove trailing newline from ext4_msg() message
      commit: 757228b71b41615b5e4f660c65b537e83e727095

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
