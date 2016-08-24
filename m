From: Eryu Guan <eguan@redhat.com>
Subject: Re: [sparc64] ext4 TPC and call trace (process blocked/stuck) on git
 kernel 4.8.0-rc3+
Date: Wed, 24 Aug 2016 16:27:36 +0800
Message-ID: <20160824082736.GQ27776@eguan.usersys.redhat.com>
References: <CADxRZqyE2HjaXzbv-9ovJM=G18C28tr7pEL8RsUx+9o870jqBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sparclinux@vger.kernel.org,
        fstests@vger.kernel.org
To: Anatoly Pugachev <matorola@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADxRZqyE2HjaXzbv-9ovJM=G18C28tr7pEL8RsUx+9o870jqBg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 24, 2016 at 11:13:25AM +0300, Anatoly Pugachev wrote:
> Hello!
> 
> Running fstests (xfstests) suite on sparc64 debian sid/unstable with
> linux kernel 4.8.0-rc3+ , I'm getting the following call trace and TPC
> on server console and system logs:
> 
> mator@nvg5120:~/xfstests-dev$ ./check ext4/022

ext4/022 is known to hang, and AFAIK the fixes are pending on review and
not merged to mainline kernel yet. Please see this patchset

https://www.spinics.net/lists/linux-ext4/msg53200.html

And ext4/022 is in dangerous group, I think you can skip it by adding
"-x dangerous" to your check options (skip all tests in dangerous
group), e.g.

./check -g auto -x dangerous

Thanks,
Eryu
