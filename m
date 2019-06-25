Return-Path: <SRS0=MPzU=UY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4301CC48BD5
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Jun 2019 07:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DEE320665
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Jun 2019 07:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfFYH4H (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 25 Jun 2019 03:56:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33800 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbfFYH4G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Jun 2019 03:56:06 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3AEB77001CAEBEF3AD3F;
        Tue, 25 Jun 2019 15:56:03 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 25 Jun
 2019 15:55:58 +0800
Subject: Re: [PATCH v5 16/16] f2fs: add fs-verity support
To:     Eric Biggers <ebiggers@kernel.org>, <linux-fscrypt@vger.kernel.org>
CC:     <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-fsdevel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20190620205043.64350-1-ebiggers@kernel.org>
 <20190620205043.64350-17-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <90495fb1-72eb-ca42-8457-ef8e969eda51@huawei.com>
Date:   Tue, 25 Jun 2019 15:55:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190620205043.64350-17-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Eric,

On 2019/6/21 4:50, Eric Biggers wrote:
> +static int f2fs_begin_enable_verity(struct file *filp)
> +{
> +	struct inode *inode = file_inode(filp);
> +	int err;
> +

I think we'd better add condition here (under inode lock) to disallow enabling
verity on atomic/volatile inode, as we may fail to write merkle tree data due to
atomic/volatile inode's special writeback method.

> +	err = f2fs_convert_inline_inode(inode);
> +	if (err)
> +		return err;
> +
> +	err = dquot_initialize(inode);
> +	if (err)
> +		return err;

We can get rid of dquot_initialize() here, since f2fs_file_open() ->
dquot_file_open() should has initialized quota entry previously, right?

Thanks,

> +
> +	set_inode_flag(inode, FI_VERITY_IN_PROGRESS);
> +	return 0;
> +}
> +
