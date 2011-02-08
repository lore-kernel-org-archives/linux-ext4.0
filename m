From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG] v2.6.38-rc3+ BUG when calling destroy_inodecache at module
 unload
Date: Tue, 08 Feb 2011 16:45:39 +0200
Message-ID: <4D515713.1070106@panasas.com>
References: <4D4AF928.9030609@panasas.com> <4D4BBAAB.4070500@tao.ma> <1296846886-sup-1431@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tm@tao.ma>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <npiggin@gmail.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:48220 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1BHOpo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 09:45:44 -0500
In-Reply-To: <1296846886-sup-1431@think>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/04/2011 09:15 PM, Chris Mason wrote:
> Excerpts from Tao Ma's message of 2011-02-04 03:36:59 -0500:
>> On 02/04/2011 02:51 AM, Boaz Harrosh wrote:
>>> Last good Kernel was 2.6.37
>>> I'm doing a "mount" then "unmount". I think root is the only created inode.
>>> rmmod is called immediately after "unmount" within a script
>>>
>>> if I only do unmount and manually call "modprobe --remove exofs" after a small while
>>> all is fine.
>>>
>>> I get:
>>> slab error in kmem_cache_destroy(): cache `exofs_inode_cache': Can't free all objects
>>> Call Trace:
>>> 77dfde08:  [<6007e9a6>] kmem_cache_destroy+0x82/0xca
>>> 77dfde38:  [<7c1fa3da>] exit_exofs+0x1a/0x1c [exofs]
>>> 77dfde48:  [<60054c10>] sys_delete_module+0x1b9/0x217
>>> 77dfdee8:  [<60014d60>] handle_syscall+0x58/0x70
>>> 77dfdf08:  [<60024163>] userspace+0x2dd/0x38a
>>> 77dfdfc8:  [<600126af>] fork_handler+0x62/0x69
>>>    
>> I also get a similar error when testing ext4 and a bug is opened there.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=27652
>>
>> And I have done some simple investigation for ext4 and It looks as if now with the new *fs_i_callback doesn't free the inode to *fs_inode_cache immediately. So the old logic will destroy the inode cache before we free all the inode object.
>>
>> Since there are more than one fs affected by this, we may need to find a way in the VFS.
> 
> Sounds like we just need a synchronize_rcu call before we delete the
> cache?
> 
> -chris

Hi Al, Nick.

Al please look into this issue. Absolutely all filesystems should be affected.
Tao Ma has attempted the below fix, but it does not help. Exact same trace
with his patch applied.

If you unmount and immediately rmmod the filesystem it will crash because of
those RCU freed objects at umount, like the root inode. Nick is not responding,
I'd try to fix it, but I don't know how.

---
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In fa0d7e3, we use rcu free inode instead of freeing the inode
> directly. It causes a problem when we rmmod immediately after
> we umount the volume[1].
> 
> So we need to call synchronize_rcu after we kill_sb so that
> the inode is freed before we do rmmod. The idea is inspired
> by Chris Mason[2]. I tested with ext4 by umount+rmmod and it
> doesn't show any error by now.
> 
> 1. http://marc.info/?l=linux-fsdevel&m=129680863330185&w=2
> 2. http://marc.info/?l=linux-fsdevel&m=129684698713709&w=2 
> 
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/super.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 74e149e..315bce9 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -177,6 +177,13 @@ void deactivate_locked_super(struct super_block *s)
>  	struct file_system_type *fs = s->s_type;
>  	if (atomic_dec_and_test(&s->s_active)) {
>  		fs->kill_sb(s);
> +		/*
> +		 * We need to synchronize rcu here so that
> +		 * the delayed rcu inode free can be executed
> +		 * before we put_super.
> +		 * https://bugzilla.kernel.org/show_bug.cgi?id=27652
> +		 */
> +		synchronize_rcu();
>  		put_filesystem(fs);
>  		put_super(s);
>  	} else {
> -- 1.6.3.GIT 

Thanks
Boaz
