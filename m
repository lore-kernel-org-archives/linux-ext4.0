From: Dexuan Cui <decui@microsoft.com>
Subject: RE: ext4: performance regression introduced by the cgroup writeback
 support
Date: Thu, 24 Sep 2015 00:15:37 +0000
Message-ID: <08750e508f1643b2a2c0bb495c91d450@SIXPR30MB031.064d.mgd.msft.net>
References: <f30d4a6aa8a546ff88f73021d026a453@SIXPR30MB031.064d.mgd.msft.net>
 <20150923161359.GB25218@ret.masoncoding.com>
 <20150923185337.GK26647@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Tejun Heo <tj@kernel.org>, Chris Mason <clm@fb.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150923185337.GK26647@mtj.duckdns.org>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> -----Original Message-----
> From: Tejun Heo [mailto:htejun@gmail.com] On Behalf Of Tejun Heo
> Sent: Thursday, September 24, 2015 2:54
> To: Chris Mason <clm@fb.com>; Dexuan Cui <decui@microsoft.com>;
> Theodore Ts'o <tytso@mit.edu>; Andreas Dilger <adilger.kernel@dilger.ca>;
> linux-ext4@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: ext4: performance regression introduced by the cgroup writeback
> support
> 
> On Wed, Sep 23, 2015 at 12:13:59PM -0400, Chris Mason wrote:
> > > The issue is: under high CPU and disk I/O pressure, *some* processes can
> suffer from a very slow write speed (e.g., <1MB/s or even only 20KB/s), while
> the normal write speed should be at least dozens of MB/s.
> 
> So, I think I know what caused this regression.  Separate wb domains
> shouldn't have been enabled on traditional hierarchies.  It doesn't
> work there and leads to multiple wb domains competing on the same
> blkcg and the bw estimation would go completely haywire.  Will update
> soon.
> 
> Thanks.
> 
> --
> tejun

Thanks a lot for the quick fix, Tejun!

I'll test the fix.
I'll report back in case it can't fix the issue --I think this is unlikely. :-)

-- Dexuan
