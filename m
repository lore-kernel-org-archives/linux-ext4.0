Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23447C4332F
	for <linux-ext4@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjKFNLK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjKFNLJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Nov 2023 08:11:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2B0BD
        for <linux-ext4@vger.kernel.org>; Mon,  6 Nov 2023 05:11:06 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55379C433C9;
        Mon,  6 Nov 2023 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1699276266;
        bh=TohJ8QBzDyvkf0vAYXUQXZVqY9K1DR8+nKfvDd8jAHA=;
        h=Date:From:To:Subject:From;
        b=INbxoi0Bf8ogumR8YyGC6PBNv+zSPcJlhcqN7oUjbj29opR3B4jJgtG+2xCtttfGo
         a5RzI7saPREqxTKCVUo3sEFwKeAbQXPa/9Fdmc6CfjHhFjVU8DSxIs88H2+wRWmTV2
         gkEnENMVDij9x29khRb5WhI7SFoLILxFjqOC5beA=
Date:   Mon, 6 Nov 2023 08:11:05 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     linux-ext4@vger.kernel.org
Subject: PSA: migrating linux-ext4 to new vger infrastructure
Message-ID: <20231106-nice-horse-of-refinement-e0702d@nitro>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Good day!

I plan to migrate the linux-ext4@vger.kernel.org list to the new
infrastructure this week. We're still doing it list-by-list to make sure that
we don't run into scaling issues with the new infra.

The migration will be performed live and should not require any downtime.
There will be no changes to how anyone interacts with the list after
migration is completed, so no action is required on anyone's part.

Please let me know if you have any concerns.

Best wishes,
-K
