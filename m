Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C8CC77B7F
	for <linux-ext4@archiver.kernel.org>; Sat, 13 May 2023 04:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjEME7o (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 13 May 2023 00:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjEME7n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 May 2023 00:59:43 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4719449C
        for <linux-ext4@vger.kernel.org>; Fri, 12 May 2023 21:59:41 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 34D4xX58020075
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 May 2023 00:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1683953975; bh=QIvOIcqpjxYGgMhk21e537adDmqHT5Ejg+fwI5KC/q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=PbJPQ6ikyC0PryHYsl1TmUqHffgBfXNIq8XXi+Lvw1DpHmKWj0KZIbl8Hi5mJL6y3
         Xnx93gBpVOZcBN/v6phddN7nWYsYXQayRMaIdbORs3um5jzcinLmBpws+MmL3SS+gx
         3NV5nzjvnSDRPwth9fYEdoWesTpVJGqmhtzIstyci4mgOvM9cWvesxG6JmNN1k7tuT
         aH8Xw3LjOx2/yR4geDSjYFlIqYtKWppE4WDBwnhpXFCpZpppVRay9rFpAsyCJHeLdi
         zMpygDDZUHdP69C3lQh05/kSBk0UnAkhnH+N3Qf7eX8tpXW3o6cgBavdmO6gVokO23
         g7pmN1ScJ+Y4w==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 75BE915C02E8; Sat, 13 May 2023 00:59:33 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        syzbot+4a03518df1e31b537066@syzkaller.appspotmail.com,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v2] ext4: Fix data races when using cached status extents
Date:   Sat, 13 May 2023 00:59:29 -0400
Message-Id: <168395396129.1443054.18017236499948982224.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230504125524.10802-1-jack@suse.cz>
References: <20230504125524.10802-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On Thu, 04 May 2023 14:55:24 +0200, Jan Kara wrote:
> When using cached extent stored in extent status tree in tree->cache_es
> another process holding ei->i_es_lock for reading can be racing with us
> setting new value of tree->cache_es. If the compiler would decide to
> refetch tree->cache_es at an unfortunate moment, it could result in a
> bogus in_range() check. Fix the possible race by using READ_ONCE() when
> using tree->cache_es only under ei->i_es_lock for reading.
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix data races when using cached status extents
      commit: 185e33d15ebf4a9d779fa78249b6cc95a071967e

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
