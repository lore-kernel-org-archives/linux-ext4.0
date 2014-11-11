From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: Remove some useless flags tests
Date: Wed, 12 Nov 2014 10:26:34 +1100
Message-ID: <20141111232634.GV28565@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
 <1415739865-2438-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415739865-2438-4-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 11, 2014 at 10:04:17PM +0100, Jan Kara wrote:
> 'flags' have XFS_ALL_QUOTA_ACCT cleared immediately on function entry.
> There's no point in checking these bits later in the function. Also
> because we check something is going to change, we know some enforcement
> bits are being added and thus there's no point in testing that later.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks sane. I'll pick this up straight away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
