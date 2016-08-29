From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH] fscrypto: fix to null-terminate encrypted
 filename in fname_encrypt
Date: Mon, 29 Aug 2016 10:51:55 -0700
Message-ID: <20160829175155.GE94184@jaegeuk>
References: <1472346808-3213-1-git-send-email-chao@kernel.org>
 <20160828051330.7kyhhvvxitghshi7@thunk.org>
 <4a1a7233-a8f5-873a-2895-a259dc0cf717@kernel.org>
 <81758b43-a82c-0526-8921-cb34d6da1c50@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>
To: Chao Yu <chao@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <81758b43-a82c-0526-8921-cb34d6da1c50@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 29, 2016 at 10:55:47PM +0800, Chao Yu wrote:
> Hi Ted, Jaegeuk,
> 
> On 2016/8/28 14:16, Chao Yu wrote:
> > Hi Ted,
> > 
> > On 2016/8/28 13:13, Theodore Ts'o wrote:
> >> On Sun, Aug 28, 2016 at 09:13:28AM +0800, Chao Yu wrote:
> >>> From: Chao Yu <yuchao0@huawei.com>
> >>>
> >>> This patch fixes to add null character at the end of encrypted filename
> 
> Since encryption functionality in ext4/f2fs was exported to vfs as fscrypot
> module, more filesystems can use it, I'm not sure, maybe other fs will traverse
> encrypted filename directly.
> 
> So, could we set this null character in fname_encrypt in advance in order to
> avoid hitting random characters behind target filename when traversing it?

When taking a look at fscrypt_fname_alloc_buffer(),

	/*  
	 * Allocated buffer can hold one more character to null-terminate the
	 * string
	 */
	crypto_str->name = kmalloc(olen + 1, GFP_NOFS);

So, there'd be an alternative way which calls kzalloc() here.

Thanks,

> 
> Thanks,
> 
> >>> in fname_encrypt, in order to avoid incorrectly traversing random data
> >>> located after target filename. The call stack is as below:
> >>>
> >>> - f2fs_add_link
> >>>  - __f2fs_add_link
> >>>   - fscrypt_setup_filename
> >>>    - fscrypt_fname_alloc_buffer		allocate buffer for @fname
> >>>    - fname_encrypt			didn't set null character for @fname
> >>>   - f2fs_add_regular_entry		init qstr with @fname
> >>>    - init_inode_metadata
> >>>     - f2fs_init_security
> >>>      - security_inode_init_security
> >>>       - selinux_inode_init_security
> >>>        - selinux_determine_inode_label
> >>>         - security_transition_sid
> >>> 	 - security_compute_sid
> >>> 	  - filename_compute_type
> >>> 	   - hashtab_search
> >>> 	    - filenametr_hash		traverse @fname as one which has null character
> >>
> >> The problem is not in fname_encrypt(), but rather that
> >> security_inode_init_security() should be given the _unencrypted_
> >> filename.
> >>
> >> In ext4 security_inode_init_security() is called with the qstr from
> >> the dentry, not the encrypted qstr --- in fact we call
> >> security_inode_init_security before we call fname_encrypt.
> >>
> >> SELinux needs the unencrypted filename in order to decide which
> >> SELinux rules / labels should apply.
> > 
> > You're right, I missed this mistake. So actually, this is a bug of f2fs.
> > Let me figure out the fixing patch.
> > 
> > Thanks for your review! :)
> > 
> > Thanks,
> > 
> >>
> >> 					- Ted
> >>
> > 
> > ------------------------------------------------------------------------------
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> > 
