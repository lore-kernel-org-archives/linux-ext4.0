From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Checking link targets are NULL-terminated
Date: Tue, 09 Dec 2008 17:30:57 +0200
Message-ID: <493E8F31.3040806@panasas.com>
References: <20081205144810.GA25585@dastardly.home.dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081205144810.GA25585@dastardly.home.dghda.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Duane Griffin wrote:
> Hi folks,
> 
> I am looking at a report of an intermittent BUG caused by an
> intentionally corrupted ext2 filesystem:
> http://bugzilla.kernel.org/show_bug.cgi?id=11412
> 
> What I think is happening is generic_readlink gets the name via
> i_ops->follow_link and passes it into vfs_readlink, without it
> necessarily being validating anywhere. If the name is not
> NULL-terminated the strlen call in vfs_readlink may run off past the end
> of the page. I think this is potentially happening in
> page_follow_link_light, as well as ext2_follow_link, so it isn't just
> ext* that is affected.
> 
> Does this sound correct, or have I missed something?
> 
> Assuming this is a real problem, does anyone have a better solution than
> scanning the name for a \0 (in ext2_follow_link and
> page_follow_link_light) and returning -ENAMETOOLONG if we can't find
> one? I.e. something like this:
> 
> diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
> index 4e2426e..9b01af2 100644
> --- a/fs/ext2/symlink.c
> +++ b/fs/ext2/symlink.c
> @@ -24,8 +24,14 @@
>  static void *ext2_follow_link(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct ext2_inode_info *ei = EXT2_I(dentry->d_inode);
> -	nd_set_link(nd, (char *)ei->i_data);
> -	return NULL;
> +	void *err = NULL;
> +
> +	if (memchr(ei->i_data, 0, sizeof(ei->i_data)) == NULL)
> +		err = ERR_PTR(-ENAMETOOLONG);
> +	else
> +		nd_set_link(nd, (char *)ei->i_data);
> +
> +	return err;
>  }

Here (Like below) Just zero the very last byte in the buffer.
The first time this buffer was strcpy to, it was including the null terminated
string. then written to inode on disk. When read, at most it could be,
is as space allocated at inode (including null). If intentionally damaged, the symlink
will be corrupted but Kernel is safe.

>  
>  const struct inode_operations ext2_symlink_inode_operations = {
> diff --git a/fs/namei.c b/fs/namei.c
> index d34e0f9..f20e94b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2750,29 +2750,49 @@ static char *page_getlink(struct dentry * dentry, struct page **ppage)
>  {
>  	struct page * page;
>  	struct address_space *mapping = dentry->d_inode->i_mapping;
> +	char *kaddr;
> +
>  	page = read_mapping_page(mapping, 0, NULL);
>  	if (IS_ERR(page))
>  		return (char*)page;
> +
> +	kaddr = kmap(page);
> +	if (memchr(kaddr, 0, PAGE_SIZE) == NULL) {
> +		kunmap(kaddr);
> +		page_cache_release(page);
> +		return ERR_PTR(-ENAMETOOLONG);
> +	}
> +

You don't need to search and fail here. All you need is to NULL terminate on
read_i_size() + 1 of inode. The length of the written string was set on write-time
the buffer is big since it is a full page and I think symlinks are limited to
less then that.

If a person damaged the symlink inode on disk (set different size) then
the data is corrupted but Kernel is still safe.

>  	*ppage = page;
> -	return kmap(page);
> +	return kaddr;
>  }
>  
>  int page_readlink(struct dentry *dentry, char __user *buffer, int buflen)
>  {
> +	int res;
>  	struct page *page = NULL;
>  	char *s = page_getlink(dentry, &page);
> -	int res = vfs_readlink(dentry,buffer,buflen,s);
> +
> +	if (IS_ERR(s))
> +		return PTR_ERR(s);
> +

Above will not fail this change is not needed

> +	res = vfs_readlink(dentry, buffer, buflen, s);
>  	if (page) {
>  		kunmap(page);
>  		page_cache_release(page);
>  	}
> +
>  	return res;
>  }
>  
>  void *page_follow_link_light(struct dentry *dentry, struct nameidata *nd)
>  {
>  	struct page *page = NULL;
> -	nd_set_link(nd, page_getlink(dentry, &page));
> +	char *name = page_getlink(dentry, &page);
> +	if (IS_ERR(name))
> +		return name;
> +

Same here

> +	nd_set_link(nd, name);
>  	return page;
>  }
>  
> Cheers,
> Duane.
> 

I hit this problem too, while developing a filesystem that was based
on ext2. The reason that it works is because the remainder of a page is always
Zero'ed out on writes. Then when read, you receive back your zero terminated link.
(Which means that if you have a symlink exactly 4k it will BUG but I guess
that is not possible).

The solution is to use the i_size information for the string length, and zero
terminate at i_size + 1.

The way I fixed it is that I Zero out the last page's remainder on read and not
on write like ext2 and other do it. (A symlink is less then 4k, right?)

Boaz

