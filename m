From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/4] percpu_stats: Enable 64-bit counts in 32-bit
 architectures
Date: Fri, 8 Apr 2016 13:46:28 -0400
Message-ID: <20160408174628.GN24661@htj.duckdns.org>
References: <1460132182-11690-1-git-send-email-Waiman.Long@hpe.com>
 <1460132182-11690-3-git-send-email-Waiman.Long@hpe.com>
 <20160408164747.GM24661@htj.duckdns.org>
 <5707EB44.9020703@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Christoph Lameter <cl@linux.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>
To: Waiman Long <waiman.long@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5707EB44.9020703@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Fri, Apr 08, 2016 at 01:32:52PM -0400, Waiman Long wrote:
> Yes, I think it will be more efficient to use percpu_counter in this case.
> The preempt_disable/enable() calls are pretty cheap. Once in a while, you
> need to take the lock and update the global count. How about I change the
> 2nd patch to use percpu_counter internally when 64-bit counts are needed in
> 32-bit archs, but use the regular percpu counts on 64-bit archs? If you are
> OK with that, I can update the patch accordingly.

Does having percpu_stats as a separate construct make sense after
that?  Just use percpu_counter directly?  You end up wasting a bit
more space that way but most of space overhead for these things are in
percpu part anyway, so in proportion it shouldn't make that much of a
difference.

Thanks.

-- 
tejun
