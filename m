Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D99AC64ED8
	for <linux-ext4@archiver.kernel.org>; Fri, 24 Feb 2023 07:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBXH6u (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 24 Feb 2023 02:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjBXH6u (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2023 02:58:50 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7921DBA1
        for <linux-ext4@vger.kernel.org>; Thu, 23 Feb 2023 23:58:48 -0800 (PST)
Received: from dggpeml500016.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PNMCG1ZbLz16Nmc;
        Fri, 24 Feb 2023 15:36:26 +0800 (CST)
Received: from [10.174.176.102] (10.174.176.102) by
 dggpeml500016.china.huawei.com (7.185.36.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 24 Feb 2023 15:38:58 +0800
Message-ID: <ae16157c-48fd-84c8-9fe5-8645395cefa6@huawei.com>
Date:   Fri, 24 Feb 2023 15:38:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2] lib/ext2fs: add some msg for io error
To:     Theodore Ts'o <tytso@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>
References: <20230223090111.680573-1-zhanchengbin1@huawei.com>
 <Y/gzOSmW70rXcjvq@mit.edu>
From:   zhanchengbin <zhanchengbin1@huawei.com>
In-Reply-To: <Y/gzOSmW70rXcjvq@mit.edu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.102]
X-ClientProxiedBy: dggpeml100010.china.huawei.com (7.185.36.14) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The e2fsck_handle_write_error is called only unix_write_blk64 and
unix_read_blk64 failed, but there is no failure message in unix_write_byte
and unix_flush.

Thanks,
  - bin.

On 2023/2/24 11:47, Theodore Ts'o wrote:
> On Thu, Feb 23, 2023 at 05:01:11PM +0800, zhanchengbin wrote:
>> Add msgs to show whether there is eio in fsck process, when write and
>> fsync methods fail.
>>
>> Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>
> 
> The libext2fs is a *library*.  As such, well designed libraries do not
> randomly write to stderr.  Consider what might happen if there was a
> curses based program that was calling libext2fs --- for example, like
> the ext2ed program.  Writing random errors to stderr is just *rude*.   :-)
> 
> If what you're worried about errors from e2fsck, it's also not
> necessary, since that's what the error handler callback is for.
> 
> Cheers,
> 
> 					- Ted
> .
> 
