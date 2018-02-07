From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv2 1/1] ext4/f2fs: don't put symlink in
 pagecache into highmem
Date: Wed, 7 Feb 2018 12:06:04 -0800
Message-ID: <20180207200604.GB15309@kroah.com>
References: <20180206235354.79591-1-jinqian@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Changman Lee <cm224.lee@samsung.com>, Chao Yu <chao2.yu@samsung.com>,
 Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
 linux-stable <stable@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 "J. Bruce Fields" <bfields@fieldses.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Jeff Layton <jlayton@poochiereds.net>,
 linux-ext4@vger.kernel.org
To: Jin Qian <jinqian@android.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20180206235354.79591-1-jinqian@android.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Some minor nits for when you send your next patch for stable:

On Tue, Feb 06, 2018 at 03:53:53PM -0800, Jin Qian wrote:
> From: Jin Qian <jinqian@google.com>

The original patch was written by Al Viro, please do not take the
original authorship off, that's not good.

> partial backport from 21fc61c73c3903c4c312d0802da01ec2b323d174 upstream
> to v4.4 to prevent virt_to_page on highmem.
> 
> ext4_encrypted_follow_link uses kmap() for cpage
>   caddr = kmap(cpage);
> 
> _ext4_fname_disk_to_usr calls virt_to_page on the kmapped address.
>   _ext4_fname_disk_to_usr()
>     ext4_fname_decrypt()
>       sg_init_one()
>         sg_init_one(&src_sg, iname->name, iname->len);
>           sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
> 
> Cc: linux-stable <stable@vger.kernel.org> # 4.4.y
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Jin Qian <jinqian@google.com>
> Signed-off-by: Jin Qian <jinqian@android.com>

Why did you sign off on this twice?

thanks,

greg k-h

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
