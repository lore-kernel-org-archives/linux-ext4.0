From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?=
 =?utf-8?B?5aSNOiDnrZTlpI06IFtQQVRDSF0gZXh0NDogZTJmc3Byb2dzOiBmaXggaW5v?=
 =?utf-8?Q?de_bitma?= =?utf-8?Q?p?= num not integer,incompatible for ancient
 android devices
Date: Sat, 30 Jun 2018 09:04:29 -0400
Message-ID: <20180630130429.GA26529@thunk.org>
References: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
 <20180627140937.GA3348@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41667@dggemm511-mbx.china.huawei.com>
 <20180628022900.GA663@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC416E8@dggemm511-mbx.china.huawei.com>
 <20180628153022.GA8521@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC4179B@dggemm511-mbx.china.huawei.com>
 <20180629142612.GE1231@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41869@dggemm511-mbx.china.huawei.com>
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
In-Reply-To: <FDC91B229D965C458E3615E98C48ADDD0EC41869@dggemm511-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 30, 2018 at 01:26:43AM +0000, Gaoming (ming, consumer BG) wrote:
> Yes, it is caused by using 1024 blocksize.
> It is historical problem, and I have to admit that's not good idea.  I don't know why somebody choose it some years before. 
> It has been corrected two years before or more early. But some ancient devices exist. 
> It is not user data, no need to do file-based encryption. It is a small partition for some use.
> 
> However, 1024 is legal though not good, somebody may use it. 
> And we should fix it.

So you understand my position --- the reason why I've been pushing so
hard is I'm trying to figure out how big of a problem this is.
Specifically speaking, is this a Huawei-specific problem, or something
across the entire Android ecosystem.  I *thought* I had fixed most of
the disaster back in 2011.  There have periodic headaches where
testers would discover problems where android handsets get bricked
after doing a factory reset that I had tracked down to make_ext4fs,
and the existence of make_ext4fs is not something I agreed to, and
have been fighting for years.  So I've been cleaning up after
make_ext4fs for a while, even though it's not my responsiblity.  (For
one thing my work responsibilities are for data center servers at
Google, *not* Android; for another, no one asked *me* before they came
up with the abomination which is make_ext4fs.)

So I don't feel particularly, or personally, responsible for bugs
caused by make_ext4fs, because if it had been up to me, it would have
never existed in the first place.

If it's only in ancient Huawei devices, I don't see a strong reason to
support his in upstream e2fsprogs.  Are you really going to be
backporting the latest e2fsprogs into these ancient Huawei devices?
In my experience, the Android team has a hard enough time getting
their Android partners to backport kernel fixes for severe security
bugs into old Android devices --- never mind versions of e2fsprogs.

If not, what's the point?

Regards,

						- Ted
