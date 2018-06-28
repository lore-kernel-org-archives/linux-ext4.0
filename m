From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGV4dDQ6?=
 =?utf-8?Q?_e2fsprogs=3A_fix_inode_bitma?= =?utf-8?Q?p?= num not
 integer,incompatible for ancient android devices
Date: Wed, 27 Jun 2018 22:29:00 -0400
Message-ID: <20180628022900.GA663@thunk.org>
References: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
 <20180627140937.GA3348@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41667@dggemm511-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liqingchao (sorp)" <sorp.liqingchao@huawei.com>,
        "Shenchen (harry)" <harry.shen@huawei.com>,
        "miaoxie (A)" <miaoxie@huawei.com>,
        "yangfei (D)" <yangfei39@huawei.com>
To: "Gaoming (ming, consumer BG)" <gaoming20@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FDC91B229D965C458E3615E98C48ADDD0EC41667@dggemm511-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 28, 2018 at 01:40:30AM +0000, Gaoming (ming, consumer BG) wrote:
> Hi tytso,
> 
> I have checked that make_ext4fs code was deleted o Jun 21th 2018 on master branch of /system/extras repository.
> e.g. 
> https://android-review.googlesource.com/c/platform/system/extras/+/708003

Make_ext4fs was fixed not create invalid file systems a *long* time
ago.  What I'm not sure about is why the patch hasn't gotten out to
more Android manufacters sooner.

It should have been fixed by sometime in 2012 --- I complained to the
Android team in early 2011.  What I don't understand is why people are
coming out of the woodwork *now*.

					- Ted
