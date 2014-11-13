From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/11] quota: Split ->set_xstate callback into two
Date: Thu, 13 Nov 2014 09:34:16 -0800
Message-ID: <20141113173416.GA31481@infradead.org>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
 <1415739865-2438-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415739865-2438-5-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 11, 2014 at 10:04:18PM +0100, Jan Kara wrote:
> Split ->set_xstate callback into two callbacks - one for turning quotas
> on (->sysquota_on) and one for turning quotas off (->sysquota_off). That
> way we don't have to pass quotactl command into the callback which seems
> cleaner.

Yes, I much prefer these to be split.  But the names seem a little odd,
why not enable_quota/disable_quota?

> +static unsigned int generic_to_xfs_flags(unsigned int uflags)

xfs_quota_flags() ?

