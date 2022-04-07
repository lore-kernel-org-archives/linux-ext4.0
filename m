Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A7FC4167E
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Apr 2022 15:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344951AbiDGPmP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Apr 2022 11:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344927AbiDGPmO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Apr 2022 11:42:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6831EADD
        for <linux-ext4@vger.kernel.org>; Thu,  7 Apr 2022 08:40:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4BCAB1F85A;
        Thu,  7 Apr 2022 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649346013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=N+DzGQPcliJDva1YLDnGs/eM1s7b7lr8flF4Rlq+iXQ=;
        b=PNGvbpRm/hT+Ia897ufYbZd8s5PXSoRZBa8fKv2XpbbI8Kx1tFozMBny6GntHygG/xY5jd
        UaFs9xx5+gKZr69yMA16GSm1I6ykueiFPXuZgG1tMCfEDn5tKLPS/QAJxCzAHgUAyNxVd6
        wBS9xxhJ6nqs5lrXYIBLcSgnsC8RJek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649346013;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=N+DzGQPcliJDva1YLDnGs/eM1s7b7lr8flF4Rlq+iXQ=;
        b=vy5VXwyw/U4VPT9bP44Nqnc5OzHck+Og40FVz4mHBOVm9wlrzzFsk4CiSOrb3YCk7w0G8V
        cQgMqp0n8pjSXgDg==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3D047A3B89;
        Thu,  7 Apr 2022 15:40:13 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C800DA061A; Thu,  7 Apr 2022 17:40:12 +0200 (CEST)
Date:   Thu, 7 Apr 2022 17:40:12 +0200
From:   Jan Kara <jack@suse.cz>
To:     Eric Whitney <enwlinux@gmail.com>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Loop device fixes
Message-ID: <20220407154012.wm7f73qw3epuim3r@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello!

Christoph's loop device fixes were posted here:

https://lore.kernel.org/all/20220330052917.2566582-1-hch@lst.de

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
