From: Chao Yu <chao@kernel.org>
Subject: Re: [PATCH] fscrypto: fix to null-terminate encrypted
 filename in fname_encrypt
Date: Sun, 28 Aug 2016 14:16:03 +0800
Message-ID: <4a1a7233-a8f5-873a-2895-a259dc0cf717@kernel.org>
References: <1472346808-3213-1-git-send-email-chao@kernel.org>
	<20160828051330.7kyhhvvxitghshi7@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chao Yu <yuchao0@huawei.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20160828051330.7kyhhvvxitghshi7@thunk.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On 2016/8/28 13:13, Theodore Ts'o wrote:
> On Sun, Aug 28, 2016 at 09:13:28AM +0800, Chao Yu wrote:
>> From: Chao Yu <yuchao0@huawei.com>
>>
>> This patch fixes to add null character at the end of encrypted filename
>> in fname_encrypt, in order to avoid incorrectly traversing random data
>> located after target filename. The call stack is as below:
>>
>> - f2fs_add_link
>>  - __f2fs_add_link
>>   - fscrypt_setup_filename
>>    - fscrypt_fname_alloc_buffer		allocate buffer for @fname
>>    - fname_encrypt			didn't set null character for @fname
>>   - f2fs_add_regular_entry		init qstr with @fname
>>    - init_inode_metadata
>>     - f2fs_init_security
>>      - security_inode_init_security
>>       - selinux_inode_init_security
>>        - selinux_determine_inode_label
>>         - security_transition_sid
>> 	 - security_compute_sid
>> 	  - filename_compute_type
>> 	   - hashtab_search
>> 	    - filenametr_hash		traverse @fname as one which has null character
> 
> The problem is not in fname_encrypt(), but rather that
> security_inode_init_security() should be given the _unencrypted_
> filename.
> 
> In ext4 security_inode_init_security() is called with the qstr from
> the dentry, not the encrypted qstr --- in fact we call
> security_inode_init_security before we call fname_encrypt.
> 
> SELinux needs the unencrypted filename in order to decide which
> SELinux rules / labels should apply.

You're right, I missed this mistake. So actually, this is a bug of f2fs.
Let me figure out the fixing patch.

Thanks for your review! :)

Thanks,

> 
> 					- Ted
> 

------------------------------------------------------------------------------
