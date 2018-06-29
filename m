From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?B?5aSNOiBbUEFUQ0hdIGV4dDQ6IGUyZnNwcm9nczogZml4IGlub2RlIGJpdG1h?=
 =?utf-8?Q?p?= num not integer,incompatible for ancient android devices
Date: Fri, 29 Jun 2018 10:26:12 -0400
Message-ID: <20180629142612.GE1231@thunk.org>
References: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
 <20180627140937.GA3348@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41667@dggemm511-mbx.china.huawei.com>
 <20180628022900.GA663@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC416E8@dggemm511-mbx.china.huawei.com>
 <20180628153022.GA8521@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC4179B@dggemm511-mbx.china.huawei.com>
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
In-Reply-To: <FDC91B229D965C458E3615E98C48ADDD0EC4179B@dggemm511-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 29, 2018 at 02:06:03AM +0000, Gaoming (ming, consumer BG) wrote:
> We use usual inode size, it is 256 bytes.
> 
> Yes, this commit is in my repository.
> But there is a bug in this patch.
> 
> Let me show you,
> Here is the bug: " return ALIGN(inodes, (info.block_size / info.inode_size));"
> 
> In my reproduce,
> info.block_size = 1024, (it is legal)
> info.inode_size =256,

But why are you using a block size of 1024?  It's legal, but in
general, it's a bad idea (often will hurt performance, will impose
additional scalability limitations, etc.)....  It's certainly not
the default.

A block size of 1024 is also incompatible with file-based encryption
(FBE), which is required for a number of Android features.  Support
for FBE is strongly required, and it wouldn't surprise me if it
becomes an mandatory requirement at some point in the future.

How long have you been using a block size of 1024, and why?

> But in real scenario, we should align by 8,( 8 bit per bytes in inode map).

Yes, and that's why mke2fs does.  make_ext4fs was an Android specific
abomination, that I've been pushing hard for Android to rid itself of.
This is not the only thing it's gotten wrong in the past, and I've had
to help Android developers deal with data corrupting bugs caused by
the fact that way back when, Android had a GPL-in-userspace allergy.

						- Ted
