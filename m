From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/8] Add tests for zero range into xfstests
Date: Thu, 13 Mar 2014 14:22:42 +1100
Message-ID: <20140313032242.GD4263@dastard>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 05, 2014 at 04:51:31PM +0100, Lukas Czerner wrote:
> Hi,
> 
> this patch set adds two new test for zero range into xfstests - generic/008
> and ext4/001. It also adds zero range support for fsstress and fsx.

Lukas, I don't see a generic test equivalent of ext4/001 in this
series? Can you please write one so that we have the same coverage
on all other supported filesystems?  The rest of the patch series is
fine, but I'd really like you to finish the job off properly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
