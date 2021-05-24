Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F60C04FF3
	for <linux-ext4@archiver.kernel.org>; Mon, 24 May 2021 16:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9746A6109F
	for <linux-ext4@archiver.kernel.org>; Mon, 24 May 2021 16:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhEXQGu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 24 May 2021 12:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbhEXQFO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 24 May 2021 12:05:14 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E266BC0612A3;
        Mon, 24 May 2021 08:19:59 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id B7C131F41D90
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     amir73il@gmail.com, kernel@collabora.com,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, jack@suse.com,
        dhowells@redhat.com, khazhy@google.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 00/11] File system wide monitoring
Organization: Collabora
References: <20210521024134.1032503-1-krisman@collabora.com>
        <YKmS0KyZ6RoCw4We@mit.edu>
Date:   Mon, 24 May 2021 11:19:50 -0400
In-Reply-To: <YKmS0KyZ6RoCw4We@mit.edu> (Theodore Y. Ts'o's message of "Sat,
        22 May 2021 19:25:05 -0400")
Message-ID: <87h7isp3ah.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

"Theodore Y. Ts'o" <tytso@mit.edu> writes:

> Hi Gabriel,
>
> Quick question; what userspace program are you using to test this
> feature?  Do you have a custom testing program you are using?  If so,
> could share it?

Hello Ted,

I'm using the program in patch 10, to watch and print notifications ,
along with corrupt filesystems. I trigger operations via command line
and watch the reports flow. I have slightly modified the sample code to
test marks disappearing at inopportune times, but that's trivial to
recreate with the samples code.

I plan to write more automated tests for LTP, once we settle on this
design.

-- 
Gabriel Krisman Bertazi
