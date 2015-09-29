From: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Tue, 29 Sep 2015 14:37:36 +0300
Message-ID: <1443526656.16309.49.camel@gmail.com>
References: <1443012552.19983.209.camel@gmail.com>
	 <20150923180934.GE26647@mtj.duckdns.org>
	 <20150923185137.GJ26647@mtj.duckdns.org>
	 <20150923210729.GA23180@mtj.duckdns.org>
	 <1443082186.19983.234.camel@gmail.com>
	 <20150924204529.GF25415@mtj.duckdns.org>
	 <1443163749.19983.254.camel@gmail.com>
	 <1443178222.10230.10.camel@gmail.com>
	 <20150925154925.GH4449@mtj.duckdns.org>
	 <1443254768.16309.46.camel@gmail.com>
	 <20150926221413.GI3572@htj.duckdns.org>
Reply-To: dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org,
	kernel-team-b10kYP2dOMg@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150926221413.GI3572-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2015-09-26 at 18:14 -0400, Tejun Heo wrote:
> Hello, Artem.
> 
> Thanks a lot for the debug dump.  Can you please test whether the
> below patch fixes the issue?

Hi,

I've tested this, 7 out of 7 reboots successful, so it looks like this
patch fixes the problem.

Artem.
