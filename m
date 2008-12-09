From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Checking link targets are NULL-terminated
Date: Tue, 09 Dec 2008 18:46:28 +0200
Message-ID: <493EA0E4.10604@panasas.com>
References: <20081205144810.GA25585@dastardly.home.dghda.com>	 <493E8F31.3040806@panasas.com> <e9e943910812090820h3cc63b5dtb767a8a11ee2bad2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <e9e943910812090820h3cc63b5dtb767a8a11ee2bad2@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Duane Griffin wrote:
> Hi Boaz, thanks for your review and comments...
> 
> 2008/12/9 Boaz Harrosh <bharrosh@panasas.com>:
>>> diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
>>> index 4e2426e..9b01af2 100644
>>> --- a/fs/ext2/symlink.c
>>> +++ b/fs/ext2/symlink.c
>>> @@ -24,8 +24,14 @@
>>>  static void *ext2_follow_link(struct dentry *dentry, struct nameidata *nd)
>>>  {
>>>       struct ext2_inode_info *ei = EXT2_I(dentry->d_inode);
>>> -     nd_set_link(nd, (char *)ei->i_data);
>>> -     return NULL;
>>> +     void *err = NULL;
>>> +
>>> +     if (memchr(ei->i_data, 0, sizeof(ei->i_data)) == NULL)
>>> +             err = ERR_PTR(-ENAMETOOLONG);
>>> +     else
>>> +             nd_set_link(nd, (char *)ei->i_data);
>>> +
>>> +     return err;
>>>  }
>> Here (Like below) Just zero the very last byte in the buffer.
>> The first time this buffer was strcpy to, it was including the null terminated
>> string. then written to inode on disk. When read, at most it could be,
>> is as space allocated at inode (including null). If intentionally damaged, the symlink
>> will be corrupted but Kernel is safe.
> 
> I considered this approach. Filesystems that allocate buffers for the
> name (e.g. XFS) already tend to unconditionally NULL-terminate it, so
> this is a non-issue for them. However others (including ext2) do not
> allocate a buffer, instead pointing to the in-memory data representing
> the on-disk data. If we NULL-terminate in those cases the in-memory
> and on-disk data would differ. If the kernel writes out the data for
> some other reason (say after updating atime) then we may
> unintentionally modify the link target. That may not be a serious
> problem in practice, but it doesn't feel right.
> 

I just want to make sure that you understand the code above and convince
you that this can/should be done and will damage nothing.

The code you see above is only for links that are shorter then some constant.
The ext2 (and other fs's) will cache this case and write the symlink directly
into the inode that will then have 0 number of data blocks. The space allocated
at inode is constant and is chosen for good inode packing on disk. The inode
starts empty then if a symlink is short the string is strcpy to above buffer.
So even if intentional damage was done to on-disk data, putting another null
at the end will never hurt. At most it is redundant since there is another
one preceding. But in the case of damage the damage is fixed. There can never
be an information lost.

For symlinks that are longer then above constant 1 data block is allocated
and the symlink is written, padded by zeros. This is taken care of by the
generic layer in the code you patched at fs/namei.c. Terminating at
i_size + 1 will never reach the disk since only i_size bytes are ever written.

> However, if the FS maintainers don't have a problem with it, it will
> certainly be cleaner and easier to implement than scanning. Opinions?
> 
> [snip]
> 
>> I hit this problem too, while developing a filesystem that was based
>> on ext2. The reason that it works is because the remainder of a page is always
>> Zero'ed out on writes. Then when read, you receive back your zero terminated link.
>> (Which means that if you have a symlink exactly 4k it will BUG but I guess
>> that is not possible).
> 
> It is not possible for an uncorrupted symlink :)
> 
>> The solution is to use the i_size information for the string length, and zero
>> terminate at i_size + 1.
>>
>> The way I fixed it is that I Zero out the last page's remainder on read and not
>> on write like ext2 and other do it. (A symlink is less then 4k, right?)
> 
> Right. If PATH_MAX is larger than PAGE_SIZE no doubt all sorts of
> things would start going horribly wrong.

Right that's what I thought. So my approach should be safe. Zero out at
i_size + 1 

> 
> Cheers,
> Duane.
> 

Thanks
Boaz
