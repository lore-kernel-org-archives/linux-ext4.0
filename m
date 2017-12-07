From: Red Swaqz <redswaqz@gmail.com>
Subject: [QUESTION] jbd2: How identify what kind of metadata is in t_buffers
Date: Fri, 8 Dec 2017 02:52:35 +0900
Message-ID: <CACFo8TGV98FkYuUpk3Qefb_ki07pa7eoYun6CwXLJLUgNXAD0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Red Swaqz <redswaqz@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:38183 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbdLGRwg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 12:52:36 -0500
Received: by mail-it0-f46.google.com with SMTP id r6so16275946itr.3
        for <linux-ext4@vger.kernel.org>; Thu, 07 Dec 2017 09:52:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is there any way to identify to what kind of metadata a specific
t_buffer is related?

On the source code it simply says that it is for metadata (in commit
phase 2b) but there is no sign of which kind of metadata these
t_buffers are storing.

Thank you.
