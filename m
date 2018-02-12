From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: ext4 iomap SEEK broken [was: [GIT PULL] ext4 updates for 4.15]
Date: Mon, 12 Feb 2018 14:34:29 +0100
Message-ID: <6db646d9-9ec0-ddda-d480-357cf3c70a09@suse.cz>
References: <20171113031502.f6mctmlmgk5psh77@thunk.org>
 <7ae851b1-92a8-779a-a066-1c7e34867465@suse.cz>
 <45062110-e80c-f1e8-3710-743c1ae4d232@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <45062110-e80c-f1e8-3710-743c1ae4d232@suse.cz>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/12/2018, 01:14 PM, Jiri Slaby wrote:
> On 02/12/2018, 11:02 AM, Jiri Slaby wrote:
>> Given this happens only on 32bit kernel, I assume some 32bit overflow.
>> But I am unable to see it (yet).
> 
> Just to add, a diff of strace in good and bad kernels:
> @@ -655,14 +655,4 @@
>  _llseek(3, 4275568640, [4286054400], SEEK_DATA) = 0
>  _llseek(3, 4286054400, [4288675840], SEEK_HOLE) = 0
>  _llseek(3, 4288675840, [4299161600], SEEK_DATA) = 0
> -_llseek(3, 4299161600, [4301783040], SEEK_HOLE) = 0
> +_llseek(3, 4299161600, [4299161600], SEEK_HOLE) = 2621440
> 
> llseek returns a very invalid value when it comes to 0x100400000.

It gets cropped to 0x400000, so:

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3523,7 +3523,7 @@ static int ext4_iomap_begin(struct inode *inode,
loff_t offset, loff_t length,
                iomap->flags |= IOMAP_F_DIRTY;
        iomap->bdev = inode->i_sb->s_bdev;
        iomap->dax_dev = sbi->s_daxdev;
-       iomap->offset = first_block << blkbits;
+       iomap->offset = (u64)first_block << blkbits;
        iomap->length = (u64)map.m_len << blkbits;

        if (ret == 0) {

sounds about right?

> regards,
-- 
js
suse labs
