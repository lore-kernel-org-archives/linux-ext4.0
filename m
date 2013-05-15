From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 05/20] xfs: use ->invalidatepage() length argument
Date: Wed, 15 May 2013 17:30:04 +1000
Message-ID: <20130515073004.GQ29466@dastard>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
 <1368549454-8930-6-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, hughd@google.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1368549454-8930-6-git-send-email-lczerner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 14, 2013 at 06:37:19PM +0200, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in xfs_vm_invalidatepage()
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Ben Myers <bpm@sgi.com>
> Cc: xfs@oss.sgi.com

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
