From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 15:49:12 +0300
Message-ID: <1443012552.19983.209.camel@gmail.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
	 <1434495193-31182-3-git-send-email-tj@kernel.org>
	 <20150722035620.GD2944@thunk.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, lizefan@huawei.com,
	cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150722035620.GD2944@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2015-07-21 at 23:56 -0400, Theodore Ts'o wrote:
> > v2: Updated for MS_CGROUPWB -> SB_I_CGROUPWB.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > Cc: linux-ext4@vger.kernel.org
> 
> Thanks, applied.

Hi, this patch introduces a regression - a major one, I'd say.

Symptoms: copy a bunch of file, run sync, then run 'reboot', and after
you boot up the copied files are corrupted. So basically the user
-visible symptom is that 'sync' does not work.

I quite an effort to bisect it, but it led me to this patch.

If I take the latest upstream (v4.3-rc2+), and revert this patch:

001e4a8 ext4: imlpement cgroup writeback support

then the problem goes away - files are not corrupted after reboot.

I use ext4 on top of a "bare" partition, no LVM or dm layers involved.

I use Fedora 22 with all the latest package updates, and I only change
the kernel there.

The corruption seems to be that the start with a bunch of zeroes
instead of the real data, but I did not check carefully, looked only at
one file briefly.

Artem.

