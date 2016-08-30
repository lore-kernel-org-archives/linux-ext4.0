From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [f2fs-dev] [PATCH] fscrypto: fix to null-terminate encrypted
 filename in fname_encrypt
Date: Wed, 31 Aug 2016 00:10:32 +0800
Message-ID: <5b07433c-02f1-8bbb-b7cd-94b0b6bc3b7e@huawei.com>
References: <1472346808-3213-1-git-send-email-chao@kernel.org>
 <20160828051330.7kyhhvvxitghshi7@thunk.org>
 <4a1a7233-a8f5-873a-2895-a259dc0cf717@kernel.org>
 <81758b43-a82c-0526-8921-cb34d6da1c50@kernel.org>
 <20160829190803.clqnlfl7qpi7tgsi@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, Chao Yu <chao@kernel.org>,
        <jaegeuk@kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160829190803.clqnlfl7qpi7tgsi@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On 2016/8/30 3:08, Theodore Ts'o wrote:
> On Mon, Aug 29, 2016 at 10:55:47PM +0800, Chao Yu wrote:
>> Hi Ted, Jaegeuk,
>>
>> Since encryption functionality in ext4/f2fs was exported to vfs as fscrypot
>> module, more filesystems can use it, I'm not sure, maybe other fs will traverse
>> encrypted filename directly.
>>
>> So, could we set this null character in fname_encrypt in advance in order to
>> avoid hitting random characters behind target filename when traversing it?
> 
> The encrypted filename is only used by the file system; it's not
> anything which is visible outside of the file system --- if it does,
> such as passing it to the security subsystem, it's a bug.
> 
> Secondly, remember that the encrypted filename is a binary blob, and
> may contain hex 00 as part of the encrypted filename.  So ***any***
> code that tries to use NULL termination for the encrypted filename by
> definition is a bug.  In other words, you must use memcpy, and not
> strcpy.  If you use strcpy, even if you did add a NUL character to the
> end of the encrypted filename (which is a bit of a misnomer because it
> is a binary blob, not an ASCII string, so NUL is really not
> technically correct), there will be encrypted filenames where strcpy
> will stop early, because there is a 0x00 byte in the encrypted
> filename.
> 
> Hence, other file systems MUST NOT traverse the encrypted filename
> directly, because treating it as a NUL-terminated string when it is
> really a binary blob of bits that can include a 0x00 byte is by
> definition a BUG.

Thanks for your detailed explain. :)

I just be misguided by comments of following code:

int fscrypt_fname_alloc_buffer(struct inode *inode,
				u32 ilen, struct fscrypt_str *crypto_str)
{
	unsigned int olen = fscrypt_fname_encrypted_size(inode, ilen);

	crypto_str->len = olen;
	if (olen < FS_FNAME_CRYPTO_DIGEST_SIZE * 2)
		olen = FS_FNAME_CRYPTO_DIGEST_SIZE * 2;
	/*
	 * Allocated buffer can hold one more character to null-terminate the
	 * string
	 */
	crypto_str->name = kmalloc(olen + 1, GFP_NOFS);
	if (!(crypto_str->name))
		return -ENOMEM;
	return 0;
}
EXPORT_SYMBOL(fscrypt_fname_alloc_buffer);

Thanks,

> 
> Cheers,
> 
> 						- Ted
> 
> .
> 
