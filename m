From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/5] ext4: Convert to generic reserved quota's space
 management. [V5]
Date: Mon, 14 Dec 2009 18:25:15 +0100
Message-ID: <20091214172514.GE4731@quack.suse.cz>
References: <1260793276-8511-1-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-2-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1260793276-8511-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 14-12-09 15:21:14, Dmitry Monakhov wrote:
> This patch fix write vs chown race condition.
> 
> Changes from V4
>  - Coding style cleanup according to Jan's comment.
> Changes from V2:
>  - add missed i_reserved_quota iniatilization.
  Looks good, merged into my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
