From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Fri, 23 Jul 2010 20:55:58 +1000
Message-ID: <20100723105558.GB7362@dastard>
References: <20100715105745.GI30737@dastard>
 <20100719224512.GD32635@dastard>
 <20100721063222.GW32635@dastard>
 <20100723104313.GA6431@atrey.karlin.mff.cuni.cz>
 <20100723105326.GB6431@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100723105326.GB6431@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 23, 2010 at 12:53:26PM +0200, Jan Kara wrote:
>   I've taken the change just updating the changelog to:
> ext3: default to ordered mode
>     
> data=writeback mode is dangerous as it leads to higher data loss and stale data
> exposure when systems crash. It should not be the default, especially when all
> major distros ensure their ext3 filesystems default to ordered mode. Change the
> default mode to the safer data=ordered mode, because we should be caring far
> more about avoiding stale data exposure than performance.
> 
>   Do you agree Dave?

Fine by me ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
