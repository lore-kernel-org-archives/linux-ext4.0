Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3FAC54EAA
	for <linux-ext4@archiver.kernel.org>; Fri, 27 Jan 2023 17:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbjA0Rrb (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 27 Jan 2023 12:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjA0Rra (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Jan 2023 12:47:30 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8867D2AB
        for <linux-ext4@vger.kernel.org>; Fri, 27 Jan 2023 09:47:28 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 30RHl07C003043
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 12:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1674841622; bh=aGEe9mvjMjdDcvfHbHPcQqZAinng9dGaYQVeh7gV+E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Y1lAe8HaBr+NaPrzQNZ6uMjYTEynHSH7TGmMR37PsqE355wVhN8sfKfcMPvgyiOXi
         kpA3VoqZH8rE6TqJNZi/h1sSqYAHLjrPAdWKGjrZBirOGC7OkdfBJpXTqGkVnQ4S6Q
         O206E8ePoWiH7snsg86s4LWFcqC23WW6N74Rh1d3c+WrEwM+Oq/y2SqWBwsGl/uL05
         n1/AEp7Fgcgw81LtdiK7HSL0vEIXG5wb/YOrx0a62lJjpgVjQ4xdKlQhmNKfOrxLXX
         D6xAOt5BXYyy6doBW7ZCgFAWInH8KEzBhkB62wqGq0TXvhQE6ZzrqqlCmkwv/EeHE1
         yNvcZ4B1UG6Cw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9A49015C3589; Thu, 26 Jan 2023 11:01:53 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "lihaoxiang (F)" <lihaoxiang9@huawei.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        "lijinlin (A)" <lijinlin3@huawei.com>, linfeilong@huawei.com,
        louhongxiang@huawei.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] mmp:fix wrong comparison in ext2fs_mmp_stop
Date:   Thu, 26 Jan 2023 11:01:52 -0500
Message-Id: <167474888836.17682.11878698054727825163.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <d791b3d2-c438-3541-76ae-d228ba7b8cd4@huawei.com>
References: <d791b3d2-c438-3541-76ae-d228ba7b8cd4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 29 Nov 2022 15:02:39 +0800, lihaoxiang (F) wrote:
> In our knowledge, ext2fs_mmp_stop use to process the rest of work
> when mmp will finish. Critically, it must check if the mmp block is
> not changed. But there exist an error in comparing the mmp and mmp_cmp.
> 
> Look to ext2fs_mmp_read, the assignment of mmp_cmp retrieve from the
> superblock of disk and it copy to mmp_buf if mmp_buf is not none
> and not equal to mmp_cmp in the meanwhile. However, ext2fs_mmp_stop
> pass the no NULL pointer fs->mmp_buf which has possed the mmp info to
> ext2fs_mmp_read. Consequently, ext2fs_mmp_read override fs->mmp_buf
> by fs->mmp_cmp so that loss the meaning of comparing themselves
> after that and worse yet, couldn't judge whether the struct of mmp
> has changed.
> 
> [...]

Applied, thanks!

[1/1] mmp:fix wrong comparison in ext2fs_mmp_stop
      (no commit info)

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
