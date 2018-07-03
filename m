From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?B?5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIGV4dDQ6IGUy?=
 =?utf-8?Q?fsprogs=3A_fix_inode_bitma?= =?utf-8?Q?p?= num not
 integer,incompatible for ancient android devices
Date: Tue, 3 Jul 2018 06:35:57 -0400
Message-ID: <20180703103557.GA27426@thunk.org>
References: <20180628022900.GA663@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC416E8@dggemm511-mbx.china.huawei.com>
 <20180628153022.GA8521@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC4179B@dggemm511-mbx.china.huawei.com>
 <20180629142612.GE1231@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41869@dggemm511-mbx.china.huawei.com>
 <20180630130429.GA26529@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41D5F@dggemm511-mbx.china.huawei.com>
 <20180702121654.GA15131@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41DC4@dggemm511-mbx.china.huawei.com>
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
In-Reply-To: <FDC91B229D965C458E3615E98C48ADDD0EC41DC4@dggemm511-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 03, 2018 at 12:58:48AM +0000, Gaoming (ming, consumer BG) wrote:
> And can you help me understand *why* such a choice was made?
> -----if there is such a problem in your devices, how will you do? Is there any other choice?
> ----- of course, you cannot format the partition.

You misunderstand my question.  Why was the choice of a blocksize of
1024 made?

I'm trying to understand how many devices, and why any other
manufacture would make, what seems to me, to be a completely insane
choice.

How long has Huawei been using a 1024 byte blocksize?  And why?  And
for how many devices?  Essentially, I'm trying to figure out if this
was a Huawei-specific mistake.

					- Ted
