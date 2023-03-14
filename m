Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E365CC74A5B
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Mar 2023 12:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCNMZz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 14 Mar 2023 08:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjCNMZB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2023 08:25:01 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBE1A3B6E;
        Tue, 14 Mar 2023 05:21:47 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PbXFq3GcwzKn40;
        Tue, 14 Mar 2023 20:02:23 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 20:02:36 +0800
Subject: Re: [PATCH v2 2/5] jbd2: remove unused feature macros
To:     Jan Kara <jack@suse.cz>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.com>,
        <tudor.ambarus@linaro.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20230313132021.672134-1-chengzhihao1@huawei.com>
 <20230313132021.672134-3-chengzhihao1@huawei.com>
 <20230314113504.xfo7q2uy6q623vzb@quack3>
From:   Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <5e3274b9-af8f-e031-0418-b400bc1f8d10@huawei.com>
Date:   Tue, 14 Mar 2023 20:02:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20230314113504.xfo7q2uy6q623vzb@quack3>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.46]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Jan,
> On Mon 13-03-23 21:20:18, Zhihao Cheng wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> JBD2_HAS_[IN|RO_]COMPAT_FEATURE macros are no longer used, just remove
>> them.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> I gave you my Reviewed-by on this patch (and a few others in this series).
> Why didn't you include it?
> 

Sorry, my fault. Will add in v3.

