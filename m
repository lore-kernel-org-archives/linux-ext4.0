Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA72C10F06
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 20:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0E412173C
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 20:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vyzkp8o6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfBQUgP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 15:36:15 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:44993 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBQUgO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2019 15:36:14 -0500
Received: by mail-qk1-f176.google.com with SMTP id r21so8866516qkl.11;
        Sun, 17 Feb 2019 12:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=PT7oxgT25K3RZvy3SEHDi45byk2PZRJaBbwW8G01tNg=;
        b=Vyzkp8o6tjwiEZNzIMe/HpWlQ5khLzPVQoxtNrFcgfpOHJyWy1Mm9HKXLBDBRZM+9G
         ssu9ixyT/emv63OlQhim+nmELhW3REkmvhgJsi6ET5urMOVYCNi3s4kPVb15Ui7giQEQ
         ARWb6SdwCgdv1wAHhlrS5z+6yn9UHW5SWsgJUejMdMAqSLNVckoE+5pz3tHyVsvkYanV
         fO6tVtt7H9FntG6JUe2S/exJ1IvcnlZXcgFfuVwL55/ycGg+vFDZy71G0Vgs6KtHLbjQ
         jfPUdtRdbQ2od0PyB/pwyNSUcAhpHIfxjAPC7D32fulF/HryBLY9ZqDkCHizQwpHjTZr
         9ROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=PT7oxgT25K3RZvy3SEHDi45byk2PZRJaBbwW8G01tNg=;
        b=FSPmG02eL9ocSMyOxLY9RtHe6XGB78vfc8SA/MG5FcII8YTwFjg8uqG+p8Hcb5Rqyr
         88PM77nvdJfED0bQPQeXUSKbPeNtupvtB2PSEVrhCYNCFZ4Dq1y6CH7+tDCT5Bt7USgE
         9NaqxA/qhj3rCWtReGBhiFWk01veKWiuxh6rb5rG/bdHtbT2v7VzWdSsOMxOIbG2Iu8P
         IWEd0fVWkxdMRrlMOH1zI18x2lya42E2vzl74UIiDlP/gz0uQ9mAW404eEmBOov8BcB7
         LZbKVD6rTZlocWPbGp/7M46UA8LB/ZsUsmbsudnJl1YiRWuf/Z4gOgrZKZxmL8o5wVDY
         ttlQ==
X-Gm-Message-State: AHQUAuaqpIhkRyexi0hCMc2UQrJ6g0ZzjI48CkBIM2g3vrL3AzwUexOa
        9TQlJju2Q/Yj0p4JZJATcussHnXE
X-Google-Smtp-Source: AHgI3IbqAk6cnZ0ybmzJaMbNarFSDZdFhiJkxUfw+q1neHRB8X94M5GafIBdRtR4KVZ/ctYMEw7Qjg==
X-Received: by 2002:a37:a407:: with SMTP id n7mr12412977qke.46.1550435772692;
        Sun, 17 Feb 2019 12:36:12 -0800 (PST)
Received: from [192.168.1.204] (pool-108-7-72-149.bstnma.fios.verizon.net. [108.7.72.149])
        by smtp.gmail.com with ESMTPSA id 132sm1117911qke.0.2019.02.17.12.36.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 12:36:11 -0800 (PST)
From:   Ric Wheeler <ricwheeler@gmail.com>
Subject: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
To:     lsf-pc@lists.linux-foundation.org
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Message-ID: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
Date:   Sun, 17 Feb 2019 15:36:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

One proposal for btrfs was that we should look at getting discard out of the 
synchronous path in order to minimize the slowdown associated with enabling 
discard at mount time. Seems like an obvious win for "hint" like operations like 
discard.

I do wonder where we stand now with the cost of the various discard commands - 
how painful is it for modern SSD's? Do we have a good sense of how discard 
performance scales as the request size increases? Do most devices "no op" a 
discard operation when issued against an already discarded region?

Would this be an interesting topic to discuss in a shared block/file system session?

Regards,

Ric


