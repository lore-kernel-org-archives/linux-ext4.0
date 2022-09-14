Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9ADC6FA82
	for <linux-ext4@archiver.kernel.org>; Wed, 14 Sep 2022 15:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiINPrg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiINPrb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2022 11:47:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803E780482
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2022 08:47:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE54A1FD9D;
        Wed, 14 Sep 2022 15:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1663170448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Y59hj1vzws9UKes6AGW1n9K4BZf3Gbd+GwHYG+XGeJ8=;
        b=0OMevKDWDGwkgQVoeS9V37xjuTdE3WhWYsAORvnM/mhWtn++KjgRXPPI+Pn4xSmzzSidhP
        MBXZxwjjdbMq1CCbboby6cKTQvCAfzXZXZZF7UCRO3eiuI9zpk0uL4nJkzbSqXn+XSHJ9a
        fsbts038RRcTKIuLrUjc6+fabOhaeFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1663170448;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Y59hj1vzws9UKes6AGW1n9K4BZf3Gbd+GwHYG+XGeJ8=;
        b=Rn0/4cNaxWz5vih5AAxbVdAsg04HF+tMQIR3t27qc1OuDUP9HUlFcxLenMxNjh1gw93mQO
        153iZgGw4rWCdvBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CF8C613A90;
        Wed, 14 Sep 2022 15:47:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7bCfMpD3IWOnVQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 14 Sep 2022 15:47:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 389D2A0680; Wed, 14 Sep 2022 17:47:28 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext2: Handle corrupted sb better
Date:   Wed, 14 Sep 2022 17:47:21 +0200
Message-Id: <20220914154450.26562-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=333; h=from:subject:message-id; bh=A7ifj+Dmroy3R/tBO+vMXoiKOodz+kakBFl/8AynIQQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjIfeBDlvI8M5MHLKNRQOP4qs+rw1tSoLIMw366b66 NBWp6DSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYyH3gQAKCRCcnaoHP2RA2Z/bB/ 0SFZPfQrQYnufqSS5zLgf+1eOTAKYjTNGeqLQYN97qjDK3jbjer8G9dxIEo2U1IDiiktB94fn5eR0h ErswwqeZyqKsjUY2B+fPyAuQ8tpdC9nzjZXhOYjlHz/x5UWA9WI01zUvvf6QD+zfFSbSuChyDPKIvw LoH7IZGZF0Wj1u9S5ETDMKPZSy9Ml/H/01sw2JTTiTPfEVhwbHpEDWvVrtN1QK1Bz5UViH9Q4uvdT4 ZyzKJuo8IYfru1IlsDexol4IgdQp3dhGrlf5u7OkKJp82+/OVDtMeA7jntA129Y0UqQPhBVzORkx5T bHykVRGa+ccPiUbP76smKw3PV55zcA
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

in response to a syzbot report this patch series adds some sanity checks of
superblock when mounting ext2 superblock. It also makes ext2 use kvmalloc()
(instead of kmalloc()) to allocate array of descriptor block buffers as it
can get considerably large. I plan to merge these patches through my tree.

								Honza
