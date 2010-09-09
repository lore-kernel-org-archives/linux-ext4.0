From: john stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][PATCH] make file's timestamp more accurate
Date: Thu, 09 Sep 2010 09:23:27 -0700
Message-ID: <1284049407.2762.19.camel@localhost.localdomain>
References: <4C7CC08A.9010302@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Chris Mason <chris.mason@oracle.com>,
	Jiri Olsa <jolsa@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Oleg Nesterov <oleg@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
	"Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58442 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab0IIQXh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 12:23:37 -0400
In-Reply-To: <4C7CC08A.9010302@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2010-08-31 at 17:42 +0900, Satoru Takeuchi wrote:
> linux has supported nanosecond order file's timestamp since 2.5.48.
> However current file timestamp is got by current_fs_time() and
> is only updated once a tick. It can't say true nanosecond accuracy.
> In addition, gettimeofday() before a file operation updating
> {a,c,m}time would outstrip file's timestamp because of the difference
> about time source between gettimeofday() and file's timestamp.
> A certain kind of application would corrupted by this problem.

Applications mixing gettimeofday and filesystem timesamps can currently
use clock_gettime(CLOCK_REALTIME_COARSE,...) - which returns tick
granular timestamps, the same as the filesystem timestamps - method to
avoid this issue.

However, Patrick LoPresti (cc'ed) was working on a similar issue here
connected to nfs.  

> I attached a most simple patch fixing this problem here. However
> it has several problems and I don't say it can be applied as is.
> The most big two problems is the following:
> 
>  - It would cause performance regression, especially in
>    not TSC capable system.
>  - Is gettimeofday()'s monotonicity reliable on all systems?

It *should* be. But hardware issues can cause trouble here.

> The relative discussion:
> http://lkml.org/lkml/2010/7/13/443
> 
> Does anybody have good idea? Should it be tunable, for example?

I think the discussion from earlier suggested that this be configurable
from a mount option so the performance/granularity trade-off can be
managed there. 

Potential pot-holes on the road here: Although I guess doing this on a
per-mount basis in the future could make it difficult for apps that use
CLOCK_REALTIME_COARSE to function if fs granularity is increased. Some
sort of CLOCK_REALTIME_FS could be introduced to map to whichever
granularity is right, but that can only be done on a global basis.
Hrm...

thanks
-john

