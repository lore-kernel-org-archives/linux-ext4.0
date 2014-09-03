From: Joakim Ziegler <joakim@terminalmx.com>
Subject: Re: What happened to e4defrag relevant file and free space defrag?
Date: Wed, 03 Sep 2014 14:26:07 -0500
Message-ID: <54076B4F.4020003@terminalmx.com>
References: <53F87552.6050000@terminalmx.com> <540760AA.4060900@terminalmx.com> <20140903190207.GJ2504@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from famine.copyleft.no ([188.94.218.115]:50265 "EHLO
	mail9.copyleft.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaICT0O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Sep 2014 15:26:14 -0400
In-Reply-To: <20140903190207.GJ2504@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/09/14, 14:02, Theodore Ts'o wrote:
> On Wed, Sep 03, 2014 at 01:40:42PM -0500, Joakim Ziegler wrote:
>> On 23/08/14, 6:04, Joakim Ziegler wrote:
>>>
>>> Also, about free space defrag, it says:
>>>
>>> "Implement free space defragmentation (e4defrag -f). We might imple=
ment this
>>> feature when the relevant defrag development is completed."
>
> The e4defrag is in e2fsprogs, and the code is still getting maintaine=
d
> and improved.  Dmitry Monakhov has in particular added a lot of
> "torture tests", and found a number of race conditions in the
> underlying kernel code.  He recently also sent a code refactor of the
> kernel code which significantly improved it and (shrank the size of
> ext4 by 550 lines of code).
>
> That being said, there hasn't been any real feature development for
> e4defrag in quite some time.  There has been some discussion about
> what the kernel API's might be to support this feature, but there has
> never been a finalized API proposal, let alone an implementation.

Yeah, I was mostly curious about the relevant file defrag, since Akira'=
s=20
presentation from a few years back said that there were patches in revi=
ew, and=20
it would, I think, largely solve my problem.

--=20
Joakim Ziegler  -  Supervisor de postproducci=F3n  -  Terminal
joakim@terminalmx.com   -   044 55 2971 8514   -   5264 0864
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
