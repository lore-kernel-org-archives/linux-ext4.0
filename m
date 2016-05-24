From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] direct-io: fix direct write stale data exposure from
 concurrent buffered read
Date: Tue, 24 May 2016 12:24:55 -0700
Message-ID: <20160524122455.4fc3d250b17fcd776dc15968@linux-foundation.org>
References: <1463156728-13357-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, viro@ZenIV.linux.org.uk
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1463156728-13357-1-git-send-email-guaneryu@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 14 May 2016 00:25:28 +0800 Eryu Guan <guaneryu@gmail.com> wrote:

> Currently direct writes inside i_size on a DIO_SKIP_HOLES filesystem are
> not allowed to allocate blocks(get_more_blocks() sets 'create' to 0
> before calling get_block() callback), if it's a sparse file, direct
> writes fall back to buffered writes to avoid stale data exposure from
> concurrent buffered read. But there're two cases that can result in
> stale data exposure are not correctly detected.
> 
> 1. The detection for "writing inside i_size" is not sufficient, writes
> can be treated as "extending writes" wrongly. For example, direct write
> 1FSB to a 1FSB sparse file on ext2/3/4, starting from offset 0, in this
> case it's writing inside i_size, but 'create' is non-zero, because
> 'block_in_file' and '(i_size_read(inode) >> blkbits' are both zero.

um, what is an "FSB"?

> 2. Direct writes starting from or beyong i_size (not inside i_size) also
> could trigger block allocation and expose stale data. For example,
> consider a sparse file with i_size of 2k, and a write to offset 2k or 3k
> into the file, with a filesystem block size of 4k. (Thanks to Jeff Moyer
> for pointing this case out in his review.)
> 
> The first problem can be demostrated by running ltp-aiodio test ADSP045
> many times. When testing on extN filesystems, I see test failures
> occasionally, buffered read could read non-zero (stale) data.
> 
> ADSP045: dio_sparse -a 4k -w 4k -s 2k -n 1
> 
> dio_sparse    0  TINFO  :  Dirtying free blocks
> dio_sparse    0  TINFO  :  Starting I/O tests
> non zero buffer at buf[0] => 0xffffffaa,ffffffaa,ffffffaa,ffffffaa
> non-zero read at offset 0
> dio_sparse    0  TINFO  :  Killing childrens(s)
> dio_sparse    1  TFAIL  :  dio_sparse.c:191: 1 children(s) exited abnormally
> 
> The second problem can also be reproduced easily by a hacked dio_sparse
> program, which accepts an option to specify the write offset.
> 
> What we should really do is to disable block allocation for writes that
> could result in filling holes inside i_size.
> 

