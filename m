From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] large-fs: fix large_fs space detection
Date: Thu, 11 Jul 2013 10:54:54 +1000
Message-ID: <20130711005454.GT3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dchinner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 09, 2013 at 03:05:15PM +0400, Dmitry Monakhov wrote:
> Currenly large_fs check compare $SCRATCH_DEV_EMPTY_SPACE and $fs_size
> which is not correct because total empty size required is $SCRATCH_DEV_EMPTY_SPACE + 50Gb
> This path fix space detection, so check becomes valid for all situations.

I'm not sure what problem you're fixing from this description?

It's takenme a few minutes to work out that:

"If SCRATCH_DEV_EMPTY_SPACE + 50GB is larger than the filesystem
size being tested, then the configuration being tested is invalid
and should fail. Currently we only check that
SCRATCH_DEV_EMPTY_SPACE is greater than the the filesystem size. Fix
it to check the combined empty space fits in the filesystem being
tested."

Otherwise the change looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
