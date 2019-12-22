Return-Path: <SRS0=pocG=2M=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B8BC2D0D2
	for <linux-ext4@archiver.kernel.org>; Sun, 22 Dec 2019 02:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26B39206C3
	for <linux-ext4@archiver.kernel.org>; Sun, 22 Dec 2019 02:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfLVCBe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 21 Dec 2019 21:01:34 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48698 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726086AbfLVCBe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Dec 2019 21:01:34 -0500
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBM21Mil030670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 Dec 2019 21:01:22 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2E027420822; Sat, 21 Dec 2019 21:01:22 -0500 (EST)
Date:   Sat, 21 Dec 2019 21:01:22 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
Subject: Re: [PATCH v2] ext4: fix Wunused-but-set-variable warning in
 ext4_add_entry()
Message-ID: <20191222020122.GB63378@mit.edu>
References: <cb5eb904-224a-9701-c38f-cb23514b1fff@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb5eb904-224a-9701-c38f-cb23514b1fff@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Dec 17, 2019 at 10:46:49PM +0800, Yunfeng Ye wrote:
> Warning is found when compile with "-Wunused-but-set-variable":
> 
> fs/ext4/namei.c: In function ‘ext4_add_entry’:
> fs/ext4/namei.c:2167:23: warning: variable ‘sbi’ set but not used
> [-Wunused-but-set-variable]
>   struct ext4_sb_info *sbi;
>                        ^~~
> Fix this by moving the variable @sbi under CONFIG_UNICODE.
> 
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>

Thanks, applied.

					- Ted
