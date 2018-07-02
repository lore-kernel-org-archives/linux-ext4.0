From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?B?5aSNOiDnrZTlpI06IOetlOWkjTogW1BBVENIXSBleHQ0OiBlMmZzcHJvZ3M6?=
 =?utf-8?Q?_fix_inode_bitma?= =?utf-8?Q?p?= num not integer,incompatible for
 ancient android devices
Date: Mon, 2 Jul 2018 08:16:54 -0400
Message-ID: <20180702121654.GA15131@thunk.org>
References: <20180627140937.GA3348@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41667@dggemm511-mbx.china.huawei.com>
 <20180628022900.GA663@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC416E8@dggemm511-mbx.china.huawei.com>
 <20180628153022.GA8521@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC4179B@dggemm511-mbx.china.huawei.com>
 <20180629142612.GE1231@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41869@dggemm511-mbx.china.huawei.com>
 <20180630130429.GA26529@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41D5F@dggemm511-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liqingchao (sorp)" <sorp.liqingchao@huawei.com>,
        "Shenchen (harry)" <harry.shen@huawei.com>,
        "miaoxie (A)" <miaoxie@huawei.com>,
        "yangfei (D)" <yangfei39@huawei.com>,
        "Renlipeng (OS driver)" <renlipeng@huawei.com>
To: "Gaoming (ming, consumer BG)" <gaoming20@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FDC91B229D965C458E3615E98C48ADDD0EC41D5F@dggemm511-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 02, 2018 at 09:34:28AM +0000, Gaoming (ming, consumer BG) wrote:
> I got it. You hate make_ext4fs, and me too.
> You don't like to merge this patch in upstream e2fsprogs to resolve the bug of make_ext4fs.
> 
> Of course we will fix the bug on our ancient devices, we have to .
> If this problem fixed or this patch merges in latest e2fsprogs, we will backport the latest e2fsprogs.
> If not, we have no motivation to backport it.
> 
> I don't know whether other android devices suffer this problem.

Can you be explicit and tell me how many Huawei devices uses a block
size of 1024?  And can you help me understand *why* such a choice was made?

     	       	       	   	   	      - Ted
