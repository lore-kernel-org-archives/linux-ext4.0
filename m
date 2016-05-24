From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] direct-io: fix direct write stale data exposure from concurrent buffered read
Date: Tue, 24 May 2016 15:39:54 -0400
Message-ID: <x49eg8r1bzp.fsf@segfault.boston.devel.redhat.com>
References: <1463156728-13357-1-git-send-email-guaneryu@gmail.com>
	<20160524122455.4fc3d250b17fcd776dc15968@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eryu Guan <guaneryu@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160524122455.4fc3d250b17fcd776dc15968@linux-foundation.org>
	(Andrew Morton's message of "Tue, 24 May 2016 12:24:55 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 14 May 2016 00:25:28 +0800 Eryu Guan <guaneryu@gmail.com> wrote:
>
>> Currently direct writes inside i_size on a DIO_SKIP_HOLES filesystem are
>> not allowed to allocate blocks(get_more_blocks() sets 'create' to 0
>> before calling get_block() callback), if it's a sparse file, direct
>> writes fall back to buffered writes to avoid stale data exposure from
>> concurrent buffered read. But there're two cases that can result in
>> stale data exposure are not correctly detected.
>> 
>> 1. The detection for "writing inside i_size" is not sufficient, writes
>> can be treated as "extending writes" wrongly. For example, direct write
>> 1FSB to a 1FSB sparse file on ext2/3/4, starting from offset 0, in this
>> case it's writing inside i_size, but 'create' is non-zero, because
>> 'block_in_file' and '(i_size_read(inode) >> blkbits' are both zero.
>
> um, what is an "FSB"?

File System Block, as opposed to a block device block.  :)

-Jeff
