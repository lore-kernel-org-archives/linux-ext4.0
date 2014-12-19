From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING2...
Date: Fri, 19 Dec 2014 13:33:39 -0800
Message-ID: <20141219133339.5c8afaa0c47760e9b141df49@linux-foundation.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
	<871toikt7c.fsf@openvz.org>
	<87zjavehsx.fsf@openvz.org>
	<20141218151247.b6ccd73351f40db66818c07e@linux-foundation.org>
	<87egrwf1dd.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
	Michael Kerrisk <mtk.manpages@gmail.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87egrwf1dd.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 19 Dec 2014 12:13:50 +0300 Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> --- a/Documentation/filesystems/fiemap.txt
> +++ b/Documentation/filesystems/fiemap.txt
> @@ -196,7 +196,8 @@ struct fiemap_extent_info {
>  };
>  
>  It is intended that the file system should not need to access any of this
> -structure directly.
> +structure directly. Filesystem handlers should be tolerant to signals and return
> +EINTR once fatal signal received.

Thanks.  I was concerned about userspace effects and back-compatibility
issues, because I'd misread fatal_signal_pending() as signal_pending().

Because it uses fatal_signal_pending(), the effects of this change
should be indiscernible to userspace, yes?

I'm now wondering if the above doc update is unneeded and incorrect. 
Is it likely that the fs handler (fiemap_fill_next_extent) will ever
consume a large amount of time?  If not then we can leave the logic in
__generic_block_fiemap() and not bother callees.



The fix only addresses filesystems which use generic_block_fiemap(). 
Presumably ocfs2, btrfs, nilfs2, lustre and xfs remain vulnerable to
the problem you identified?
