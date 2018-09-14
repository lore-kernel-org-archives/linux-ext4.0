From: Dave Chinner <david@fromorbit.com>
Subject: Re: metadata operation reordering regards to crash
Date: Sat, 15 Sep 2018 08:23:36 +1000
Message-ID: <20180914222336.GD16550@dastard>
References: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
To: =?utf-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 14, 2018 at 05:06:44PM +0800, 焦晓冬 wrote:
> Hi, all,
> 
> A probably bit of complex question:
> Does nowadays practical filesystems, eg., extX, btfs, preserve metadata
> operation order through a crash/power failure?

Yes.

Behaviour is filesystem dependent, but we have tests in fstests that
specifically exercise order preservation across filesystem failures.

> What I know is modern filesystems ensure metadata consistency
> after crash/power failure. Journal filesystems like extX do that by
> write-ahead logging of metadata operations into transactions. Other
> filesystems do that in various ways as btfs do that by COW.
> 
> What I'm not so far clear is whether these filesystems preserve
> metadata operation order after a crash.
> 
> For example,
> op 1.  rename(A, B)
> op 2.  rename(C, D)
> 
> As mentioned above,  metadata consistency is ensured after a crash.
> Thus, B is either the original B(or not exists) or has been replaced by A.
> The same to D.
> 
> Is it possible that, after a crash, D has been replaced by C but B is still
> the original file(or not exists)?

Not for XFS, ext4, btrfs or f2fs. Other filesystems might be
different.

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
