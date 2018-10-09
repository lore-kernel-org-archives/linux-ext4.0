Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-dm3nam03on0067.outbound.protection.outlook.com ([104.47.41.67]:54352
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbeJIUne (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Oct 2018 16:43:34 -0400
From: Jan Glauber <Jan.Glauber@cavium.com>
To: Dmitry Vyukov <dvyukov@google.com>
CC: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: KASAN: use-after-scope in ext4_group_desc_csum
Date: Tue, 9 Oct 2018 13:26:34 +0000
Message-ID: <20181009132625.GC21519@hc>
References: <20181005101629.GA21469@hc>
 <CACT4Y+ZQr4DZtTLUxAe4HrC6=fQBQCJcs4U5xVjqsz8wu8uH8g@mail.gmail.com>
 <20181005130506.GA5972@hc>
 <CACT4Y+bY=Ota1E_tf_QgsT9d2YdQ7xXE0k=Q1VPJga=Ge+1UpA@mail.gmail.com>
In-Reply-To: <CACT4Y+bY=Ota1E_tf_QgsT9d2YdQ7xXE0k=Q1VPJga=Ge+1UpA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8DE22F174853542BCDF666DF230FC50@namprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 05, 2018 at 05:32:07PM +0200, Dmitry Vyukov wrote:
[...]

> This all makes me think that somebody else has left these 0xf8 in
> shadow before ext4_map_blocks started executing.
> Unfortunately debugging garbage in stack shadow is not completely
> trivial and there is no common recipe. I don't have setup to run arm64
> kernel at the moment. I would try to locate that garbage in stack
> shadow earlier, e.g. calling another function before ext4_map_blocks,
> implementing that function in mm/kasan/kasan.c (non-instrumented
> itself) and then try to scan stack and verify presence of 0xf8
> garbage. If this works out, then try to catch garbage earlier and/or
> try to figure out what function left that garbage (that's possible by
> locating 0x41b58ab3 magic:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D198435).

Thanks a lot for your analysis! I'll try to debug this further but as
you pointed out it might be difficult to catch who writes beforehand to
that location.

--Jan
