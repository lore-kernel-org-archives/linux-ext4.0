From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext4: use module parameters instead of debugfs for
 mballoc_debug
Date: Mon, 11 Feb 2013 09:48:01 -0600
Message-ID: <511912B1.9070407@redhat.com>
References: <1360460534-818-1-git-send-email-tytso@mit.edu> <51191010.50402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab3BKPry (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:47:54 -0500
In-Reply-To: <51191010.50402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/11/13 9:36 AM, Eric Sandeen wrote:
> On 2/9/13 7:42 PM, Theodore Ts'o wrote:
>> There are multiple reasons to move away from debugfs.  First of all,
>> we are only using it for a single parameter, and it is much more
>> complicated to set up (some 30 lines of code compared to 3), and one
>> more thing that might fail while loading the ext4 module.
>>
>> Secondly, as a module paramter it can be specified as a boot option if
>> ext4 is built into the kernel, or as a parameter when the module is
>> loaded, and it can also be manipulated dynamically under
>> /sys/module/ext4/parameters/mballoc_debug.  So it is more flexible.
>>
>> Ultimately we want to move away from using mb_debug() towards
>> tracepoints, but for now this is still a useful simplification of the
>> code base.
>>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> Good idea.

As another thought, did you consider using dynamic debug for this, or is that
too much trickiness?  Might be nice since usually a bug reporter won't have
a kernel built with CONFIG_EXT4_DEBUG . . .

-Eric

> My only suggestion would be to add parameter information to the descriptions -
> default value and permissible value range?  I guess nothing enforces that
> like for proc entries, right?
> 
>  "Debugging level for ext4's mballoc: 0/1 (default 0)"
> 
> (hm, we never pass anything but "1" o_O)
> 
> It doesn't seem like the values need sanity checking at module load time,
> but maybe it'd be worth it just out of paranoia.
> 
> Updating Documentation/filesystems/ext4.txt would be good too.
> 
> Thanks,
> -Eric
> 
> -Eric
> 
>> ---
>>  fs/ext4/mballoc.c | 47 +++++++++--------------------------------------
>>  fs/ext4/mballoc.h |  4 ++--
>>  2 files changed, 11 insertions(+), 40 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index e350885..6540ebe 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -23,11 +23,18 @@
>>  
>>  #include "ext4_jbd2.h"
>>  #include "mballoc.h"
>> -#include <linux/debugfs.h>
>>  #include <linux/log2.h>
>> +#include <linux/module.h>
>>  #include <linux/slab.h>
>>  #include <trace/events/ext4.h>
>>  
>> +#ifdef CONFIG_EXT4_DEBUG
>> +ushort ext4_mballoc_debug __read_mostly;
>> +
>> +module_param_named(mballoc_debug, ext4_mballoc_debug, ushort, 0644);
>> +MODULE_PARM_DESC(mballoc_debug, "Debugging level for ext4's mballoc");
>> +#endif
>> +
>>  /*
>>   * MUSTDO:
>>   *   - test ext4_ext_search_left() and ext4_ext_search_right()
>> @@ -2660,40 +2667,6 @@ static void ext4_free_data_callback(struct super_block *sb,
>>  	mb_debug(1, "freed %u blocks in %u structures\n", count, count2);
>>  }
>>  
>> -#ifdef CONFIG_EXT4_DEBUG
>> -u8 mb_enable_debug __read_mostly;
>> -
>> -static struct dentry *debugfs_dir;
>> -static struct dentry *debugfs_debug;
>> -
>> -static void __init ext4_create_debugfs_entry(void)
>> -{
>> -	debugfs_dir = debugfs_create_dir("ext4", NULL);
>> -	if (debugfs_dir)
>> -		debugfs_debug = debugfs_create_u8("mballoc-debug",
>> -						  S_IRUGO | S_IWUSR,
>> -						  debugfs_dir,
>> -						  &mb_enable_debug);
>> -}
>> -
>> -static void ext4_remove_debugfs_entry(void)
>> -{
>> -	debugfs_remove(debugfs_debug);
>> -	debugfs_remove(debugfs_dir);
>> -}
>> -
>> -#else
>> -
>> -static void __init ext4_create_debugfs_entry(void)
>> -{
>> -}
>> -
>> -static void ext4_remove_debugfs_entry(void)
>> -{
>> -}
>> -
>> -#endif
>> -
>>  int __init ext4_init_mballoc(void)
>>  {
>>  	ext4_pspace_cachep = KMEM_CACHE(ext4_prealloc_space,
>> @@ -2715,7 +2688,6 @@ int __init ext4_init_mballoc(void)
>>  		kmem_cache_destroy(ext4_ac_cachep);
>>  		return -ENOMEM;
>>  	}
>> -	ext4_create_debugfs_entry();
>>  	return 0;
>>  }
>>  
>> @@ -2730,7 +2702,6 @@ void ext4_exit_mballoc(void)
>>  	kmem_cache_destroy(ext4_ac_cachep);
>>  	kmem_cache_destroy(ext4_free_data_cachep);
>>  	ext4_groupinfo_destroy_slabs();
>> -	ext4_remove_debugfs_entry();
>>  }
>>  
>>  
>> @@ -3876,7 +3847,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
>>  	struct super_block *sb = ac->ac_sb;
>>  	ext4_group_t ngroups, i;
>>  
>> -	if (!mb_enable_debug ||
>> +	if (!ext4_mballoc_debug ||
>>  	    (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED))
>>  		return;
>>  
>> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
>> index 3ccd889..08481ee 100644
>> --- a/fs/ext4/mballoc.h
>> +++ b/fs/ext4/mballoc.h
>> @@ -37,11 +37,11 @@
>>  /*
>>   */
>>  #ifdef CONFIG_EXT4_DEBUG
>> -extern u8 mb_enable_debug;
>> +extern ushort ext4_mballoc_debug;
>>  
>>  #define mb_debug(n, fmt, a...)	                                        \
>>  	do {								\
>> -		if ((n) <= mb_enable_debug) {		        	\
>> +		if ((n) <= ext4_mballoc_debug) {		        \
>>  			printk(KERN_DEBUG "(%s, %d): %s: ",		\
>>  			       __FILE__, __LINE__, __func__);		\
>>  			printk(fmt, ## a);				\
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

