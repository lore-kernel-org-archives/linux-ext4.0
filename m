From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for Nov 22 (ext4 + dax)
Date: Wed, 23 Nov 2016 04:19:35 +1100
Message-ID: <20161123041935.6644679f@canb.auug.org.au>
References: <20161122213032.2a88af29@canb.auug.org.au>
        <bdfc4395-0df1-15d2-d084-3b84944dcbe7@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <bdfc4395-0df1-15d2-d084-3b84944dcbe7@infradead.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Randy,

On Tue, 22 Nov 2016 08:48:39 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:
>
> on i386:
> 
> I don't see why this is happening but I reproduced it multiple times.
> 
> fs/built-in.o: In function `ext4_dax_fault':
> file.c:(.text+0x6278b): undefined reference to `dax_iomap_fault'
> file.c:(.text+0x627dc): undefined reference to `dax_iomap_fault'
> fs/built-in.o: In function `ext4_file_write_iter':
> file.c:(.text+0x62bbc): undefined reference to `dax_iomap_rw'
> file.c:(.text+0x62d75): undefined reference to `dax_iomap_rw'
> fs/built-in.o: In function `ext4_file_read_iter':
> file.c:(.text+0x63756): undefined reference to `dax_iomap_rw'
> fs/built-in.o: In function `ext4_block_zero_page_range':
> inode.c:(.text+0x68c24): undefined reference to `iomap_zero_range'
> 
> Full randconfig file is attached.

CONFIG_FS_IOMAP is not set ...

-- 
Cheers,
Stephen Rothwell
