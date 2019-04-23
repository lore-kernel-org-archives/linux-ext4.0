Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C50C282E1
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 17:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D671E2148D
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 17:01:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RqhWYJb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfDWRBm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 13:01:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53602 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfDWRBm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Apr 2019 13:01:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3NGwuBd074988;
        Tue, 23 Apr 2019 17:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=jauTGI0QuKhlNI9wqiFh2SPVCPvHt3fN0WdqjL20X38=;
 b=RqhWYJb0bnLBrtk+kJN9fw8GXr3NFSkIR2YOMuukRJ0b2pcOducfJYnMp1rIo+6q+8ew
 RS4WIXUyWV14nnra/C2tc8rMW1BRT517t2TWZD50HODj5pHQVoToGlzFzx4Bh4DJGLyK
 UvdOgVRNq6dcikp+/B0CoMjXCFVttOTe4KX5fbeCXGcKnelCugeCjsU20e6pPBRuL/5M
 qySVU0J+MXGYVCW7xHyCJRMSw4woh4ETQ1CeTBSzLtN/5LTXlyzHxxHpWmlhhjYRHW5u
 KKC1o/GM5cM3B8dNYzEi1AfqGSZ293Oy4nHNJIclzD5XuJVTW9jJsGxwhoUIQTbuMZ5I HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ryv2q5fm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Apr 2019 17:01:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3NH1G2g004576;
        Tue, 23 Apr 2019 17:01:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ryrhs6bvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Apr 2019 17:01:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3NH1TTp022749;
        Tue, 23 Apr 2019 17:01:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Apr 2019 10:01:29 -0700
Date:   Tue, 23 Apr 2019 10:01:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, bo.li.liu@oracle.com, viro@zeniv.linux.org.uk,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: 5a9d929d6e13 ("iomap: report collisions between directio and
 buffered writes to userspace")
Message-ID: <20190423170127.GA26119@magnolia>
References: <20190423163021.GA185682@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423163021.GA185682@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904230116
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904230116
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 23, 2019 at 09:30:22AM -0700, Zubin Mithra wrote:
> Hello,
> 
> Syzkaller has triggered a kernel WARNING with the following stacktrace when fuzzing a 4.14 kernel.
> 
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0xb7/0x107 lib/dump_stack.c:53
>  panic+0x1c9/0x3ae kernel/panic.c:181
>  __warn+0x160/0x1a8 kernel/panic.c:543
>  report_bug+0x123/0x18b lib/bug.c:186
>  fixup_bug+0x3e/0x77 arch/x86/kernel/traps.c:177
>  do_error_trap+0xdd/0x1e6 arch/x86/kernel/traps.c:295
>  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:944
>  do_blockdev_direct_IO+0x1b08/0x1b95 fs/direct-io.c:1373
>  ext4_direct_IO_write fs/ext4/inode.c:3696 [inline]
>  ext4_direct_IO+0x8de/0xdad fs/ext4/inode.c:3826
>  generic_file_direct_write+0x223/0x36b mm/filemap.c:2927
>  __generic_file_write_iter+0x12f/0x2f8 mm/filemap.c:3106
>  ext4_file_write_iter+0x97d/0xade fs/ext4/file.c:264
>  call_write_iter include/linux/fs.h:1782 [inline]
>  do_iter_readv_writev+0x1e4/0x27c fs/read_write.c:678
>  do_iter_write+0x136/0x18f fs/read_write.c:957
>  vfs_iter_write+0x81/0x98 fs/read_write.c:970
>  iter_file_splice_write+0x4dc/0x7a6 fs/splice.c:749
>  do_splice_from fs/splice.c:851 [inline]
>  direct_splice_actor+0x11e/0x129 fs/splice.c:1018
>  splice_direct_to_actor+0x342/0x5b0 fs/splice.c:973
>  do_splice_direct+0x180/0x1ff fs/splice.c:1061
>  do_sendfile+0x3e6/0x61c fs/read_write.c:1438
>  SYSC_sendfile64 fs/read_write.c:1499 [inline]
>  SyS_sendfile64+0xe9/0x128 fs/read_write.c:1485
>  do_syscall_64+0x203/0x241 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> 
> Could the following patch be applied in order to v4.14.y(The patch is present in v4.19.y)?
> 5a9d929d6e13 ("iomap: report collisions between directio and buffered writes to userspace")

That patch only teaches the kernel to emit warnings in dmesg when
programs mix directio and buffered writes.  It doesn't fix any buggy
directio usage.  Someone on the ext4 list [cc'd] might know more about
this.

--D

> 
> Tests run:
> - Chrome OS tryjobs
> - Syzkaller reproducer
> 
> 
> Thanks,
> - Zubin
