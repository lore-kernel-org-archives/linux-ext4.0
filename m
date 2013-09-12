From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Wed, 11 Sep 2013 22:42:31 -0500
Message-ID: <52313827.80103@redhat.com>
References: <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org> <522FDFCC.1070007@redhat.com> <20130911113001.GB13315@thunk.org> <52309F27.8060008@redhat.com> <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz> <5230D739.9010109@redhat.com> <20130911212523.GE13397@thunk.org> <5230D450.7000609@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
	aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
	aswin_proj@lists.hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3ILDpN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Sep 2013 23:45:13 -0400
In-Reply-To: <5230D450.7000609@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/11/13 3:36 PM, Thavatchai Makphaibulchoke wrote:

> I seem to be seeing the same thing as Eric is seeing.

...
> For both filesystems, the security xattr are about 32.17 and 34.87 bytes respectively.
...

Can you triple-check the inode size on your fs, for good measure?

dumpe2fs -h /dev/whatever | grep "Inode size"

> I also see a similar problem with filefrag.

turns out it's not a problem, it's an undocumented & surprising "feature."  :(

        /* For inline data all offsets should be in bytes, not blocks */
        if (fm_extent->fe_flags & FIEMAP_EXTENT_DATA_INLINE)
                blk_shift = 0;

because ... ?  (the commit which added it didn't mention anything about it).

But I guess it does mean for at least those files, the xattr data is actually inline.

> At this point, I'm not sure why we get into the mbcache path when
> SELinux is enabled. As mentioned in one my earlier replies to
> Andreas, I did see actual calls into ext4_xattr_cache.
> 
> There seems to be one difference between 3.11 kernel and 2.6 kernel
> in set_inode_init_security(). There is an additional attempt to
> initialize evm xattr. But I do not seem to be seeing any evm xattr in
> any file.
> 
> I will continue to try to find out how we get into the mbcache path.
> Please let me know if anyone has any suggestion.

Sorry we got so far off the thread of the original patches.

But it seems like a mystery worth solving.

Perhaps in ext4_xattr_set_handle() you can instrument the case(s) where it
gets into ext4_xattr_block_set().

Or most simply, just printk inode number in ext4_xattr_block_set() so
you can look at them later via debugfs.

And in here,

        } else {
                error = ext4_xattr_ibody_set(handle, inode, &i, &is);
                if (!error && !bs.s.not_found) {
                        i.value = NULL;
                        error = ext4_xattr_block_set(handle, inode, &i, &bs);
                } else if (error == -ENOSPC) {
                        if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
                                error = ext4_xattr_block_find(inode, &i, &bs);
                                if (error)
                                        goto cleanup;
                        }
                        error = ext4_xattr_block_set(handle, inode, &i, &bs);

maybe print out in the ext4_xattr_ibody_set error case what the size of
of the xattr is, and probably inode number again for good measure, to get
an idea of what's causing it to fail to land in the inode?

-Eric

> 
> Thanks,
> Mak.


