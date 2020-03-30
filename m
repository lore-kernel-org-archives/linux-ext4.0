Return-Path: <SRS0=Hrun=5P=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E9CC43331
	for <linux-ext4@archiver.kernel.org>; Mon, 30 Mar 2020 09:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D91E206CC
	for <linux-ext4@archiver.kernel.org>; Mon, 30 Mar 2020 09:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgC3JJh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Mar 2020 05:09:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:39836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbgC3JJh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Mar 2020 05:09:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 89704AEB8;
        Mon, 30 Mar 2020 09:09:36 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id F32D71E0E20; Mon, 30 Mar 2020 11:09:35 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] Fixes for dir_index support in libext2fs
Date:   Mon, 30 Mar 2020 11:09:30 +0200
Message-Id: <20200330090932.29445-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

here are two small fixes that I've spotted in the new support for adding
entries into indexed directories.

								Honza
