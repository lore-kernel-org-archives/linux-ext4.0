Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F66C74A5B
	for <linux-ext4@archiver.kernel.org>; Sun, 26 Mar 2023 14:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjCZOcS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 26 Mar 2023 10:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjCZOcR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Mar 2023 10:32:17 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E4B59DB
        for <linux-ext4@vger.kernel.org>; Sun, 26 Mar 2023 07:32:14 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 32QEVSd2018070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 26 Mar 2023 10:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1679841090; bh=reTq5b8AdCClbmbCHpzsyP33WQkknS1xVNdQSn336A4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=YmO44llxt4F9Qwx1FpLFwZMGLxwzjv8uSAr5h7gDnPgxQDjxU3XKSf9XQSfKxc9/z
         oiLRlzFH5+9plHMZIUum4wf3butHh8Np23wmaOqou4ijfjGUk+b6xHTbx7reIAZDEx
         swObFgRBkf3Zx/hqoZD5p6AlXBKDD9rR/c+CxO91bpyHmvX10eGiBo9tw8+zrdcDW2
         eSREIsgPlybHEpFlF7PCrqn7MT/T/egzNPa59a9ab32Am/Eu4WuMf+2kx69wcvbFl/
         QNEC2sFTkDnyHjVr+hfG9ZTCRQOtEXc+03k6E7X+YVWD+gMo7JHW7ZRhtXNsVlij8K
         j6eNMiJWjZz2g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id A903515C46FF; Sun, 26 Mar 2023 10:31:28 -0400 (EDT)
Date:   Sun, 26 Mar 2023 10:31:28 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     zhanchengbin <zhanchengbin1@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linfeilong@huawei.com,
        louhongxiang@huawei.com, liuzhiqiang26@huawei.com
Subject: Re: [PATCH 0/2] Add some msg for io error
Message-ID: <20230326143128.GA436186@mit.edu>
References: <20230325065652.2111384-1-zhanchengbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325065652.2111384-1-zhanchengbin1@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Mar 25, 2023 at 02:56:50PM +0800, zhanchengbin wrote:
> If there is an EIO during the process of fsck, the user can be notified of it.

Can you identify a code path where the user is *not* getting notified
while e2fsck is running without this patch series?

The unix_io.c module calls fsync() through unix_flush() only.  When
unix_write_byte() calls flush_cached blocks(), if the read or write
system call fails, the error will be returned to the caller of
flush_cached_byte(), and the unix_write_byte() will return the error
back to the caller (in this case, e2fsck).

So in both cases, e2fsck checks the error return from ext2fs_flush()
(which is the only place where write_byte gets called) and
io_channel->flush(), and so the user will get some kind of error
report already.

The error message might not identify exactly what I/O failed, but the
"Error sync" message that this commit series provides is not going to
be much better.

						- Ted
