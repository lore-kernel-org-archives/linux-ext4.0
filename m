From: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Thu, 24 Sep 2015 10:17:19 -0600
Message-ID: <5604220F.503@fb.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org> <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
 <20150923185137.GJ26647@mtj.duckdns.org>
 <20150923210729.GA23180@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
	<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, <kernel-team-b10kYP2dOMg@public.gmane.org>,
	<adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150923210729.GA23180-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 09/23/2015 03:07 PM, Tejun Heo wrote:
> inode_cgwb_enabled() gates cgroup writeback support.  If it returns
> true, each inode is attached to the corresponding memory domain which
> gets mapped to io domain.  It currently only tests whether the
> filesystem and bdi support cgroup writeback; however, cgroup writeback
> support doesn't work on traditional hierarchies and thus it should
> also test whether memcg and iocg are on the default hierarchy.
>
> This caused traditional hierarchy setups to hit the cgroup writeback
> path inadvertently and ended up creating separate writeback domains
> for each memcg and mapping them all to the root iocg uncovering a
> couple issues in the cgroup writeback path.
>
> cgroup writeback was never meant to be enabled on traditional
> hierarchies.  Make inode_cgwb_enabled() test whether both memcg and
> iocg are on the default hierarchy.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Link: http://lkml.kernel.org/g/1443012552.19983.209.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Link: http://lkml.kernel.org/g/f30d4a6aa8a546ff88f73021d026a453-NHRYisGuqk8ni+flWUsx/pbBmlrREI7+ECdVDZe1NQc@public.gmane.org
> ---
> Hello,
>
> So, this should make the regression go away.  It doesn't fix the
> underlying bugs but they shouldn't get triggered by people not
> experimenting with cgroup.
>
> I'm gonna keep digging the underlying issues but this should make the
> regressions go away.  If it's okay, I think it'd be better to route
> this through cgroup/for-4.3-fixes as it's gonna cause a conflict with
> for-4.4 branch and handling the merge there is easier.
>
> Thanks.
>
>   include/linux/backing-dev.h |   11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)

I'll ack this since it works around both the corruption issue and the 
performance regression, so we can avoid having to revert parts of this. 
And I know you'll keep hunting and get the real issue fixed in the mean 
time.

Acked-by: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>

-- 
Jens Axboe
