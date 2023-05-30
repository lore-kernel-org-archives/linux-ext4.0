Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5972EC7EE23
	for <linux-ext4@archiver.kernel.org>; Tue, 30 May 2023 19:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjE3T05 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 30 May 2023 15:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjE3T05 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 May 2023 15:26:57 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7ACF3
        for <linux-ext4@vger.kernel.org>; Tue, 30 May 2023 12:26:55 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 34UJQcn4011211
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 15:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1685474799; bh=+RBGDeGogQI3m/O5GgY4pvKNI7n7ap2xn9ppd754A5k=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=JwKtYeJIuUbVczpTcWgaq6g0vhUgAY0zOxmZ11f0cr5QHHow2uI3kzw2jvOvLD5Ue
         JuajNqrbVlTnvdjmjpaPxCCBgFs6LztISB8nxEfndVDcokJCp9PWLD4ffNHXj61YqM
         mPZbUDxRH8n6PNfFi/j71yaNimhh2Zo2jgQiB97jPSIOcFSx5co2pycneAGZevGDag
         bdu/DxcrSnpxAsEUgUS8fq3Ai+6la4vREIMB97RZNcZMZDYyy2SO69kzlJqAhytUCJ
         Zbqs4OGvGgM+AQIrwSUDuAFq89S6WvF3i9D4jDzSvlMP9t3TLZaXwZb3HFGbOiGHjm
         MbJOAiqnlQsGA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id DC0A415C02EF; Tue, 30 May 2023 15:26:37 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 0/4] ext4: clean up ea_inode handling
Date:   Tue, 30 May 2023 15:26:35 -0400
Message-Id: <168547476045.200310.15125157661151567390.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230524034951.779531-1-tytso@mit.edu>
References: <20230524034951.779531-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On Tue, 23 May 2023 23:49:47 -0400, Theodore Ts'o wrote:
> This fixes a number of problems with ea_inode handling which were
> pointed out by syzbot.  The first and third add some additional
> checking for invalid / maliciously fuzzed file systems.  The second
> and fourth patch adds some lockdep annotations to avoid some false
> positive reports from lockdep.
> 
> There is still one remaining syzbot report[1] relating to ea_inodes
> not handled by this patch series, and that is an apparently deadlock
> which happens when a kernel thread is freeing an ea_inode racing with
> another thread which is trying to find the mbcache entry (presumably
> with the intent of reusing it).  The problem is apparently hard to
> reproduce; it's only been hit 4 times, and there is no C reproducer;
> just a syzkaller reproducer.  So we'll leave that for another day/
> 
> [...]

Applied, thanks!

[1/4] ext4: add EA_INODE checking to ext4_iget()
      commit: b3e6bcb94590dea45396b9481e47b809b1be4afa
[2/4] ext4: set lockdep subclass for the ea_inode in ext4_xattr_inode_cache_find()
      commit: d08927b3e89fde1b224d22d2bddcb8dc4fe616db
[3/4] ext4: disallow ea_inodes with extended attributes
      commit: 1e0e51238f151e26ccd0a8bd5f5cf32e85c19ac3
[4/4] ext4: add lockdep annotations for i_data_sem for ea_inode's
      commit: f901459a1f277ed921e255d4c3d54485769f7dbd

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
