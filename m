From: Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH v2 0/2] Handle invalid os_type in e2p.
Date: Tue, 18 Jul 2017 14:48:21 -0700
Message-ID: <20170718214823.22649-1-abuchbinder@google.com>
References: <20170718192919.32406-1-abuchbinder@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35563 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbdGRVs3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 17:48:29 -0400
Received: by mail-pg0-f49.google.com with SMTP id v190so19544429pgv.2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 14:48:29 -0700 (PDT)
Received: from buckle.svl.corp.google.com ([100.116.144.78])
        by smtp.gmail.com with ESMTPSA id m196sm7853224pga.33.2017.07.18.14.48.28
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 18 Jul 2017 14:48:28 -0700 (PDT)
In-Reply-To: <20170718192919.32406-1-abuchbinder@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi! Here's a new version with the updates suggested by Andreas Dilger,
specifically to switch the order (to not break git bisect) and for the
test to avoid including a binary blob.

Adam Buchbinder
Google, Inc.
