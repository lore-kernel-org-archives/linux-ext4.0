From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH] ext4: fix to propagate error from dquot_initialize()
Date: Mon, 17 Sep 2018 16:33:17 +0800
Message-ID: <2aad2a3c-f606-f511-8222-8e2e18b4a2ba@huawei.com>
References: <20180917072246.25457-1-yuchao0@huawei.com>
 <CAP9B-QmoV0RtDMpuKhEAgg4Pq+38bbPoXwXWdkFV8DHzopW-8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        "Ext4 Developers List" <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chao@kernel.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAP9B-QmoV0RtDMpuKhEAgg4Pq+38bbPoXwXWdkFV8DHzopW-8g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Shilong,

On 2018/9/17 16:18, Wang Shilong wrote:
> Hi Chao,
> 
>    I sent a early patch  series which included this but forgot  to send to
> f2fs list..
> https://patchwork.ozlabs.org/patch/968759/

Oh, sorry, I didn't notice that one.

To all, please ignore this reduplicated one.

> 
> It looks Ted still have some questions for my first patch, so that second patch
> is not applied yet..
> 
> Thanks,
> 
