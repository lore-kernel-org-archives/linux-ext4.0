From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOltleHQ0OmRldiAzNy80?=
 =?utf-8?Q?0=5D_fs=2Fext4=2Fextents=5Fstatus=2Ec=3A510=3A22?= =?utf-8?Q?=3A?=
 warning: 'es1' may be used uninitialized in this function
Date: Fri, 1 Feb 2013 12:54:21 -0500
Message-ID: <20130201175421.GC5228@thunk.org>
References: <aa4d06e5-f29a-4a98-8a3d-2d80729a993c@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?5paH5Y2/?= <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46531 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078Ab3BARyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Feb 2013 12:54:24 -0500
Content-Disposition: inline
In-Reply-To: <aa4d06e5-f29a-4a98-8a3d-2d80729a993c@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 01, 2013 at 01:52:56PM +0800, =E6=96=87=E5=8D=BF wrote:
> Ted,
> I notice that the patch series of extent status tree has been
> applied into dev branch of ext4.  Would you please fix this bug
> directly?  I will also fix it in next version.  In next version, it
> will contains some other fixes that are suggested by Jan Kara.

Yes, I applied the latest version of your patches into the dev branch
precisely so it could get more testing, including the automated sparse
runs by Wu Fengguang.

I can certainly fix small bugs in the patch series, or if you want to
send me either (a) diffs against what's currently in the dev branch,
or (b) a new patch series, I'll very happily update the dev branch
(the dev branch is one where I will rewind the branch and fix up
commits before pushing to Linus; everything after the master branch is
guaranteed to be cast into concrete, and it's likely that after the
weekend I'll push the master branch to 091e26dfc15.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
