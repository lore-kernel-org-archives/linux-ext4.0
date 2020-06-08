Return-Path: <SRS0=KfeM=7V=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC2D6C433E0
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Jun 2020 01:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96406206A4
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Jun 2020 01:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgFHBiA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Jun 2020 21:38:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5793 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728065AbgFHBiA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Jun 2020 21:38:00 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5776DBCF7928A71F4C0D;
        Mon,  8 Jun 2020 09:37:58 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.206) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 8 Jun 2020
 09:37:53 +0800
Subject: Re: [PATCH v2] f2fs: avoid utf8_strncasecmp() with unstable name
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-ext4@vger.kernel.org>, Daniel Rosenberg <drosen@google.com>,
        <stable@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
References: <20200601200805.59655-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <a2849e34-879d-783a-761e-5ce9a1d43311@huawei.com>
Date:   Mon, 8 Jun 2020 09:37:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200601200805.59655-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2020/6/2 4:08, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
> it may be concurrently modified by a rename.  This can cause undefined
> behavior (possibly out-of-bounds memory accesses or crashes) in
> utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
> that may be concurrently modified.
> 
> Fix this by first copying the filename to a stack buffer if needed.
> This way we get a stable snapshot of the filename.
> 
> Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
> Cc: <stable@vger.kernel.org> # v5.4+
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Daniel Rosenberg <drosen@google.com>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
