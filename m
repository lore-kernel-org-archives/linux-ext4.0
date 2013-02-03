From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= Help to know the stable ver
 of ext4 for commercial app.
Date: Sun, 3 Feb 2013 07:55:30 -0500
Message-ID: <20130203125530.GA4584@thunk.org>
References: <BB7C62C2B0732E4DA93834A501E8464544E6181A@SZXEML519-MBS.china.huawei.com>
 <20130202032307.GA16364@thunk.org>
 <BB7C62C2B0732E4DA93834A501E8464544E62844@SZXEML519-MBS.china.huawei.com>
 <9FEF1A06-2C24-4D37-A896-3C63D7AB29FE@dilger.ca>
 <BB7C62C2B0732E4DA93834A501E8464544E62883@SZXEML519-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, "tm@tao.ma" <tm@tao.ma>,
	"xiaoqiangnk@gmail.com" <xiaoqiangnk@gmail.com>,
	Lizefan <lizefan@huawei.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Wuqixuan <wuqixuan@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46762 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3BCMzm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Feb 2013 07:55:42 -0500
Content-Disposition: inline
In-Reply-To: <BB7C62C2B0732E4DA93834A501E8464544E62883@SZXEML519-MBS.china.huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 03, 2013 at 07:13:19AM +0000, Wuqixuan wrote:
> 
>      Thanks, I will check and compare the latest RHEL6 2.6.32 ext4 and the 2.6.32.x and 2.6.34.x in the vanilla kernel. 

I think you will find that they are quite different.

>      BTW, even now I can see in 2.6.32.x version in vanilla kernel,
>still there are some patches are checked in. But not very
>frequently. There are 5 in 2011, and 4 in 2012.

In general, these are the patches which applied trivially, so it woud
not require any special expertise to backport them.  In many cases,
these are what could be called "one-liners".

>So do you mean Redhat
>does not checkin all the patches which backport in RHEL6 to the
>vanilla kernel ?

That's correct.  It is not their responsibility to update generic
2.6.32.x kernels.  Keep in mind that when distributions talk about
"upstream first", what they mean is that new features and new drivers
get developed in the tip of the latest development upstream kernel,
and then get backported to whatever ancient "enterprise kernel" (i.e.,
2.6.32.x, et. al) that their customers pay $$$ to for them to support.

In some cases, when distributions fix a bug in their ancient 2.6.32.x
kernels for one of their paying customers, they will make point of
checking to see if the bug still applies in the development upstream
kernel, and if it does, they will submit a patch to the upstream
kernel.  Those are the distributions I will tend to help out.  But
when a company like Montavista comes out of nowhere, without having
contributed anything to ext4, and then asks for free engineering help
for their commercial kernel, it's likely that they free engineering
help they will receive will be minimal....

>      And do you know how about the stability of other distrubutions, like Windriver 4 sp3 ? 

You should really ask Windriver, and not the upstream lists.  Keep in
mind that for an upstream development engineer, commercial kernels
tend to be considered evolutionary dead ends....

							- Ted
