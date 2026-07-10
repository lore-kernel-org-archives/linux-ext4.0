Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC83233958;
	Fri, 10 Jul 2026 05:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.125.252.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783662853; cv=none; b=ueCD2zFrv+MdlRfIJHrHCJdhZo9HanZ55ZK/uRY8v2OQNFNLp5ENywz/DMih1EI0vWDe8BbiGhjXkG2ncSCxwBLfLaw5NJcTj2rAwjnC1i+C7132BtbKDJVFuKva1RfsB2+DHWa+gBYpoEqEGKsy/0rpIvbhwPnmwYTsjY2SClo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783662853; c=relaxed/simple;
	bh=nyDBnktELM+hz7RvTSyEr5tTXDizK+ufnQXY3jTKq48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHnNTng40LYlxMTCqM6XcjVREF4/k/oaH9ahfyy5Arw+jpXnGc2i8Ro68QoH8dv0kZTkQHDUG5mFrx9Gx8Rpj42bJHAz2j5bVoS/6hG1WcF2kODfR8+yWe798+pf5Lz/2Ys5KXyOkrwWnt1aveZUFtJtjAV3PUMe3YYQo+V6YOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com; spf=pass smtp.mailfrom=sk.com; arc=none smtp.client-ip=166.125.252.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sk.com
X-AuditID: a67dfc5b-c45ff70000001609-cb-6a5088f7cfdd
Date: Fri, 10 Jul 2026 14:53:54 +0900
From: Byungchul Park <byungchul@sk.com>
To: Gary Guo <gary@garyguo.net>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	boqun.feng@gmail.com, longman@redhat.com, yunseong.kim@ericsson.com,
	ysk@kzalloc.com, yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
	gustavo@padovan.org, christian.koenig@amd.com,
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, bjorn3_gh@protonmail.com, lossin@kernel.org,
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v19 31/40] dept: assign unique dept_key to each distinct
 wait_for_completion() caller
Message-ID: <20260710055354.GA37630@system.software.com>
References: <20260706061928.66713-1-byungchul@sk.com>
 <20260706061928.66713-32-byungchul@sk.com>
 <DJSEK3KA2ECQ.1512A4KGOBSCV@garyguo.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJSEK3KA2ECQ.1512A4KGOBSCV@garyguo.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTdxTG93/vNDR56WT7C7t2LltYdOIlHp0xkizxTeaGyZYscR9mI+9G
	paBpBcHEKGNIvYDYbHa0CuU2uVQg5TJXMDKEAmYd2LFSMy6WmzhaFaTVAaUrVTO//fKc5zzn
	+XA4UlbJxHDKtMOiOk2hkjMSSuKNLF37RLvnwPpsezRoc4/DxXozA1pLEQ09g99RMOrTInD1
	XyfB3JRNgGHKyIJ3tJWGQb8HwUR7HoLAhRQoKWtkYNHeR0Kpe5iEJtsIgsnCZhIGfA8YuPX7
	DIJLRh2CnPJ6BoYu6Agw6qcJWHLHg632LgvD536koM7bR8PMlI6B0e6TNMwPuAkwn50iQWv1
	UWAZd9JQVDwUaheYR2C7OkbAn9aLDIyYgzT0Gqop+Nt+joU+6xUaKgdvEeC+46LBVTiJ4Lbe
	w4Kj3URA1ayehuprdgZspleg+Xougrzp1lCngn8o6Kz/hYAbPg8BTl0JA/aWmywYswsQaDv9
	JDTMXmag4I9d8KRhPNSutoaBKwEnAmPXCLtzp5DrCDCCudiMhPnKHFJY8P3FCNf8Jkq4WYaF
	ilMLhHDevlb41TDMCiZLumCpOcUIljkdK5QuTpPCkLONEXp+WqSEiQE9sWfNXsn2JFGlzBDV
	H+7YJ0nuqmihDhVHZVqn2sgTaFZ6GkVwmN+Eg3W11HMe62yjV5ji38XeHA+7wgz/Hna5/iVX
	eBX/JrbUlBGnkYQj+aI3sMPfG154mU/BS1X3wiYpD/iGszxskvH5CNsWjPTTQRTuLZoIXyP5
	OOxavhcycSGOxZeXuRU5gt+MHzbNhQ9H8+/g9pbucA7mxyLwD03BZ01X49+qXFQh4g0vxBpe
	iDX8H2tCZA2SKdMyUhVK1aZ1yVlpysx1+w+mWlDoeX8+tvTVVTTX/3kH4jkkj5SuP554QEYr
	MjRZqR0Ic6R8lfTOayFJmqTIOiqqD36tTleJmg4Uy1HyV6Ub/EeSZPy3isNiiigeEtXPpwQX
	EXMCfbT68dmSjEcboh7sqBYeJSYc5S59sezemOh4W7mldZ7dpo0MNH7g399g8yWc2V5uD3q8
	j83tL/V8Ulea3510X+yK7y52n+wTtlYob79Fzk1+s9uTrylMOO/I/D5Gr7qf93GjpGHX+0FZ
	+mdL2XfjzlQd+3T89X39bbutX0Y3z2xrdcTKKU2yIj6OVGsU/wHjrPZquAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH877n9PTQWT0UCCdek5rFhEyRTZIn2bKLmXpivPCNhCzRRk9G
	5aJpEWUJU6iN1ampTVqk9QJFKitMsCCOSyMBrUPnbLlIo7DCUuu6giBQCJeWnWKMfnnye57n
	/8vzfnhpQrYkWk0r8wt4Vb4iV05JSMm+LzWbZ3UZR7bet6aCTnsKBn1+ETwv6SAhPK0j4Wp9
	HQURyz0x6BzlIvhjoJQE9+1aBL6wDsHsgoUAbcsSCRGDSwzTcy/FYCxBsOR0ITB5DAR43fcJ
	qGsqwTDVEKUg1DWJwDjip6AsWELCuO0CAnPAIobgw10w5msTwdLQawwDM6MIbP4oBn/HWQQR
	Uw7csDYKummCgoWnzwgoM7oRVI4METAZHEbQ5PobgbOmlIJX+rsE9PpXQl94nIJu4y8UjHmu
	YnjTQEFFqVMEnj9DCK5ZDAgCL5wYNFX1FJiuOUhoGW4Vgye0iGHQZMBQ69gLPluAhCd6Kxae
	K6TuJIOlTIOF8i8G429tGOZsdvG31Yib1V4iOXtjM+a0PRGKq7teh7iFeQPipqs1BKfVC23X
	6DjBnWk8wVU/GaW4+XA/xTlnKkjusZXlbp6bx9zlp5u5FvOQOOO7LMlXh/lcZSGvSv36oCT7
	4c1m8tj1+JOtgXbiNHorPY/iaJbZxv7zoF0UY5L5lB3TjIpjTDGbWK93johxIrOBddit+DyS
	0ARTvp7tmeleFhKYHHaxJrgckjLAdj2vWg7JmIuIdc1bRO8W8Wx3uZ+MMcGksN5oUAjRAq9h
	b0Xp2DiOSWcnmiaXDycxG9mO5kdYj6Tmj2zzR7b5g12BCDtKVOYX5imUuelb1DnZRfnKk1sO
	Hc1zIOFb2ooXL/+Opnt3dSKGRvIV0q2n9h+RiRSF6qK8TsTShDxROrxWGEkPK4p+4lVHD6iO
	5/LqTrSGJuXJ0t2Z/EEZ86OigM/h+WO86v0W03GrT6NNrXcKip9lq88W7zBMeONTd//X03ku
	lLh36pXsojnl5aNP0jrazUWRAcnaK+4+Q8iV3PD5TllCZtKqxuTt4YxfM+9VfpEU/N7zwD5Y
	2+/ybf+mH+uyVuzYqV73Q3Pv20D6SNvdqopV6/V861Rl9K8+RVZC8DO38/XjffXMngvlB9J+
	lpPqbEVaCqFSK/4HtzJC/ZIDAAA=
X-CFilter-Loop: Reflected

On Tue, Jul 07, 2026 at 03:18:29PM +0100, Gary Guo wrote:
> On Mon Jul 6, 2026 at 7:19 AM BST, Byungchul Park wrote:
> > wait_for_completion() can be used at various points in the code and it's
> > very hard to distinguish wait_for_completion()s between different usages.
> > Using a single dept_key for all the wait_for_completion()s could trigger
> > false positive reports.
> >
> > Assign unique dept_key to each distinct wait_for_completion() caller to
> > avoid false positive reports.
> >
> > While at it, add a rust helper for wait_for_completion() to avoid build
> > errors.
> 
> This will cause Rust code to share the same dept_key, so it will have all the
> false positives that the change is trying to avoid.

Thank you for the input.

> In general it is easy to create Rust bindings for static inline C functions
> because it'll be just some computation, while creating bindings for C
> function-like macros that define additional statics can be challenging.
> 
> Is dept_key similar to lock_class_key, where only the address matters? If so,
> the approach that I use in
> https://lore.kernel.org/rust-for-linux/DJP0CDOR98N5.29BK8PUFRWRUK@garyguo.net

Yes, dept_key is similar to lock_class_key.  IIUC, the way you tried for
lock_class_key can be applied to DEPT too.  I will do:

   1) add 'key' parameter to sdt_might_sleep_start_timeout()
   2) introduce init_completion_dkey() to allow custom keys
   3) remove init_completion_dmap() and adjust the existing users

Just in case, it's worth noting that the custom keys must be
well-managed using e.g. dept_key_destroy() when the key gets freed.

	Byungchul

> could be used for dept_key as well, then we can keep Rust `wait_for_completion`
> still a function; otherwise we have to turn it into a macro too on the Rust side
> to create such statics, which isn't ideal.
> 
> Best,
> Gary
> 
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  include/linux/completion.h | 100 +++++++++++++++++++++++++++++++------
> >  kernel/sched/completion.c  |  60 +++++++++++-----------
> >  rust/helpers/completion.c  |   5 ++
> >  3 files changed, 120 insertions(+), 45 deletions(-)
