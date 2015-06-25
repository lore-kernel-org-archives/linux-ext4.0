From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Thu, 25 Jun 2015 00:54:30 -0400
Message-ID: <20150625045430.GG14324@thunk.org>
References: <20150625034626.GA21682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150625034626.GA21682@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Linus,

Here's my suggested merge resolution to deal with Al Viro's symlink changes.

       	  	    	  	     	     - Ted

diff --cc fs/ext4/symlink.c
index ba5bd18,68e915a..0000000
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@@ -35,19 -34,20 +34,17 @@@ static const char *ext4_follow_link(str
  	int res;
  	u32 plen, max_size = inode->i_sb->s_blocksize;
  
- 	ctx = ext4_get_fname_crypto_ctx(inode, inode->i_sb->s_blocksize);
- 	if (IS_ERR(ctx))
- 		return ERR_CAST(ctx);
 -	if (!ext4_encrypted_inode(inode))
 -		return page_follow_link_light(dentry, nd);
 -
+ 	res = ext4_get_encryption_info(inode);
+ 	if (res)
+ 		return ERR_PTR(res);
  
  	if (ext4_inode_is_fast_symlink(inode)) {
  		caddr = (char *) EXT4_I(inode)->i_data;
  		max_size = sizeof(EXT4_I(inode)->i_data);
  	} else {
  		cpage = read_mapping_page(inode->i_mapping, 0, NULL);
- 		if (IS_ERR(cpage)) {
- 			ext4_put_fname_crypto_ctx(&ctx);
+ 		if (IS_ERR(cpage))
 -			return cpage;
 +			return ERR_CAST(cpage);
- 		}
  		caddr = kmap(cpage);
  		caddr[size] = 0;
  	}
@@@ -77,14 -78,13 +75,12 @@@
  	/* Null-terminate the name */
  	if (res <= plen)
  		paddr[res] = '\0';
- 	ext4_put_fname_crypto_ctx(&ctx);
 -	nd_set_link(nd, paddr);
  	if (cpage) {
  		kunmap(cpage);
  		page_cache_release(cpage);
  	}
 -	return NULL;
 +	return *cookie = paddr;
  errout:
- 	ext4_put_fname_crypto_ctx(&ctx);
  	if (cpage) {
  		kunmap(cpage);
  		page_cache_release(cpage);
