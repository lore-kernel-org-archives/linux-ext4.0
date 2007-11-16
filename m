From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Thu, 15 Nov 2007 18:59:19 -0800
Message-ID: <20071115185919.7df4cda9.akpm@linux-foundation.org>
References: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Nov 2007 11:47:27 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> Currently fdatasync is identical to fsync in ext3,4.
> I think fdatasync should skip journal flush in data=ordered and data=writeback mode
> because this syscall is not required to synchronize the metadata.

I suppose so.  Although one wonders what earthly point there is in syncing
a file's data if we haven't yet written out the metadata which is required
for locating that data.

IOW, fdatasync() is only useful if the application knows that it is overwriting
already-instantiated blocks.

In which case it might as well have used fsync().  For ext2-style filesystems,
anyway.

hm.  It needs some thought.
