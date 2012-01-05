From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Thu, 5 Jan 2012 14:16:06 -0800
Message-ID: <20120105141606.5e19a08b.akpm@linux-foundation.org>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1325774407-28531-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu,  5 Jan 2012 15:40:04 +0100
Jan Kara <jack@suse.cz> wrote:

> 
>   Hello,
> 
>   for mostly historical reasons we still clear buffer_uptodate flag on write
> IO errors.

I have long and strong memories of never being able to understand why
we did that.

> This is not only semantically wrong (buffer still has correct data
> in it) but it also triggers warnings in mark_buffer_dirty when buffer is
> written again which scares lots of users (as they tend to unplug USB sticks
> too early). This patch series is an attempt to start solving the problem
> by allowing filesystem to tell whether it wishes buffer_uptodate flag cleared
> on write IO error. Ext2 is converted to use this as an example. Eventually
> when all filesystems are converted, we can remove the condition.
> 
> Do people think this is a desirable way to go?
> 

Linus might have some thoughts.
