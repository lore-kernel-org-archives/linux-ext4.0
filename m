From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 13:53:37 -0400
Message-ID: <20150923175337.GD25218@ret.masoncoding.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923172535.GC25218@ret.masoncoding.com>
 <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-ext4@vger.kernel.org>, <hannes@cmpxchg.org>,
	<axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, <linux-fsdevel@vger.kernel.org>,
	<lizefan@huawei.com>, <cgroups@vger.kernel.org>,
	<adilger.kernel@dilger.ca>, <kernel-team@fb.com>,
	<linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 23, 2015 at 08:41:25PM +0300, Artem Bityutskiy wrote:
>    Hi
> 
>    $ sync
>    $ reboot

If this is case, it should be possible to reproduce with:

cp a bunch of stuff to /ext4
unmount /ext4
mount ext4
compare data

If you're not getting a clean unmount of the test FS during the reboot,
its a different test.  Trying to reproduce here, so far its clean.
Could you please double check for failed unmounts?

Thanks,
Chris
