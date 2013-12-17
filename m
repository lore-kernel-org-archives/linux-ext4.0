From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 4/10] xfsprog: xfsio: Add support
 FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Wed, 18 Dec 2013 08:01:37 +1100
Message-ID: <20131217210137.GF31386@dastard>
References: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
 <52B08446.3080102@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk,
	bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	Ashish Sangwan <a.sangwan@samsung.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Rich Johnston <rjohnston@sgi.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52B08446.3080102@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 17, 2013 at 11:05:10AM -0600, Rich Johnston wrote:
> This patch stands alone and has been committed.
> 
> Thanks
> --Rich
> 
> commit ca692f162d36c871c9c1b6169136b2c70503f2d8
> Author: Namjae Jeon <namjae.jeon@samsung.com>
> Date:   Sun Dec 8 14:11:30 2013 +0000
> 
>     xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

<sigh>

Rich, we've been here before:

19e73c9 Revert "[RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE"

Please go back and read the discussion that lead to that revert.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
