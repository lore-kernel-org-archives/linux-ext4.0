Return-Path: <SRS0=rAxa=3N=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A771C32771
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Jan 2020 04:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D7A22071A
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Jan 2020 04:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579839391;
	bh=EuvhQIPwiMkjWMW2ISI1mewp2CJ8ykDJLYX5MlF0CcQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=kTia8qJPpd57fqpqKiLHMQakYMq3JZfFdSP4L/mfU3++4cbISFLtuuKifkXs8jjta
	 mhYOHSuaCEAlLfoazTbJp09YNmtanZ14UxjhvtUc9okpBkiOlwPj/hatRjh81BryoK
	 CnQ2jI3BWSF1UW5nGytwwEEgPHTQ7Rrl+FGCTD1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgAXEQ2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbgAXEQ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 23 Jan 2020 23:16:27 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D921620708;
        Fri, 24 Jan 2020 04:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579839387;
        bh=EuvhQIPwiMkjWMW2ISI1mewp2CJ8ykDJLYX5MlF0CcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=eHP+pS+NYDGAIxKniN2dbZQLhV5h2aQqWDa5h43MbjEDunKHq2LKx0at1fs1MIFlN
         0d8O3rmwM54wrTjSxdwZE5wLfZDrnfnrHDECzeBF4MXFfO8fBUoMmaoVR2xsyw5iwg
         cZivPEaFmaNZp1k470qU0S5EE09fFOcpBvpMGNug=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH 0/2] f2fs: fixes for f2fs_d_compare() and f2fs_d_hash()
Date:   Thu, 23 Jan 2020 20:15:47 -0800
Message-Id: <20200124041549.159983-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This series fixes dentry comparisons and hashing on f2fs filesystems
with the encoding feature enabled.

Eric Biggers (2):
  f2fs: fix dcache lookup of !casefolded directories
  f2fs: fix race conditions in ->d_compare() and ->d_hash()

 fs/f2fs/dir.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.25.0

