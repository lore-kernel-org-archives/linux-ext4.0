From: Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH 0/2] Handle invalid os_type in e2p.
Date: Tue, 18 Jul 2017 12:29:17 -0700
Message-ID: <20170718192919.32406-1-abuchbinder@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34211 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdGRT3Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 15:29:24 -0400
Received: by mail-pg0-f44.google.com with SMTP id 123so17885076pgj.1
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 12:29:24 -0700 (PDT)
Received: from buckle.svl.corp.google.com ([100.116.144.78])
        by smtp.gmail.com with ESMTPSA id h27sm6793480pfd.34.2017.07.18.12.29.22
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 18 Jul 2017 12:29:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi! While fuzzing with american fuzzy lop, I discovered an issue in
the e2p library. The fix there seemed straightforward, but I'm not
sure I understand the testing infrastructure; running dumpe2fs looks
like the easiest way to trigger the problem. Any feedback here would
be welcome. Thanks!

Adam Buchbinder
Google, Inc.
