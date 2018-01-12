From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 1/8] ext4: use EXT4_INODE_ENCRYPT flag to detect
 encrypted bio
Date: Fri, 12 Jan 2018 11:04:04 -0800
Message-ID: <35d7ab9a-4b87-606c-84b0-0fb3ad5e0580@infradead.org>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-2-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112141129.27507-2-chandan@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/12/18 06:11, Chandan Rajendra wrote:
> For supporting encryption in blocksize < pagesize scenario,
> bio->bi_private field will be needed to hold the address of the
> encryption context structure. Hence this commit uses
> ext4_encrypted_inode() to detect the encryption status of a file.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/ext4/readpage.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index 9ffa6fa..0be590b 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -50,7 +50,13 @@
>  static inline bool ext4_bio_encrypted(struct bio *bio)
>  {
>  #ifdef CONFIG_EXT4_FS_ENCRYPTION
> -	return unlikely(bio->bi_private != NULL);
> +        if (bio->bi_vcnt) {
> +                struct inode *inode = bio->bi_io_vec->bv_page->mapping->host;
> +                if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
> +                        return true;

There are lots of spaces instead of tabs above...

> +	}
> +
> +	return false;
>  #else
>  	return false;
>  #endif
> 


-- 
~Randy
