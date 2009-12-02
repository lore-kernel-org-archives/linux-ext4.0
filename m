From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: Use slab allocator for sub-page sized allocations
Date: Wed, 02 Dec 2009 12:31:58 -0700
Message-ID: <BA994610-D8E1-4CEB-8D98-4D2B47595A02@sun.com>
References: <1259716451-26901-1-git-send-email-tytso@mit.edu>
 <1259716451-26901-2-git-send-email-tytso@mit.edu> <4B169B86.4040707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Brian Behlendorf <behlendorf1@llnl.gov>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34389 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZLBTcG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Dec 2009 14:32:06 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB2JW9f5013364
	for <linux-ext4@vger.kernel.org>; Wed, 2 Dec 2009 11:32:11 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KU100B00I04O100@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Dec 2009 11:32:09 -0800 (PST)
In-reply-to: <4B169B86.4040707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-12-02, at 09:53, Eric Sandeen wrote:
> So, this undoes commit c089d490dfbf53bc0893dc9ef57cf3ee6448314d
> more or less, right:
>
> JBD: Replace slab allocations with page allocations
>
> Author: Mingming Cao <cmm@us.ibm.com>
>
> JBD allocate memory for committed_data and frozen_data from slab.  
> However JBD should not pass slab pages down to the block layer.
> Use page allocator pages instead. This will also prepare JBD for the  
> large blocksize patchset.
>
> Was alignment the only reason that commit went in?

The reason had to do with the block layer, but I don't recall if  
alignment was the only reason for it.

> Also, there is a race issue here I think, that we've had bugs
> on internally, but w/ the above commit it didn't matter anymore:
>
> If you simultaneously mount several jbd(2)-based filesystems
> at once, before the slabs get created, nothing protects jbd2_slab[]
> and we can race on creation/initialization of that array.
>
> See also https://bugzilla.lustre.org/show_bug.cgi?id=19184
>
> and a proposed patch:
>
> https://bugzilla.lustre.org/attachment.cgi?id=22906
>
> but I think that patch is a little heavy-handed, the down_reads
> of the slab lock seem to be extraneous because if the fs is mounted,
> nobody will be tearing down that slab anyway, since that only
> happens on module unload, right?

Right, the slabs should only be created once, but they can never be  
destroyed while in use, so the rest of the locking is superfluous,  
though it at least deserves to be replaced by a comment indicating why  
no locking is needed for it.

>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>> fs/jbd2/journal.c    |  116 ++++++++++++++++++++++++++++++++++++++++ 
>> ++++++++++
>> include/linux/jbd2.h |   11 +----
>> 2 files changed, 118 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 3f473fa..8e0c0a9 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -39,6 +39,8 @@
>> #include <linux/seq_file.h>
>> #include <linux/math64.h>
>> #include <linux/hash.h>
>> +#include <linux/log2.h>
>> +#include <linux/vmalloc.h>
>>
>> #define CREATE_TRACE_POINTS
>> #include <trace/events/jbd2.h>
>> @@ -92,6 +94,7 @@ EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
>>
>> static int journal_convert_superblock_v1(journal_t *,  
>> journal_superblock_t *);
>> static void __journal_abort_soft (journal_t *journal, int errno);
>> +static int jbd2_journal_create_slab(size_t slab_size);
>>
>> /*
>>  * Helper function used to manage commit timeouts
>> @@ -1247,6 +1250,13 @@ int jbd2_journal_load(journal_t *journal)
>> 		}
>> 	}
>>
>> +	/*
>> +	 * Create a slab for this blocksize
>> +	 */
>> +	err = jbd2_journal_create_slab(be32_to_cpu(sb->s_blocksize));
>> +	if (err)
>> +		return err;
>> +
>> 	/* Let the recovery code check whether it needs to recover any
>> 	 * data from the journal. */
>> 	if (jbd2_journal_recover(journal))
>> @@ -1806,6 +1816,111 @@ size_t journal_tag_bytes(journal_t *journal)
>> }
>>
>> /*
>> + * JBD memory management
>> + */
>> +
>> +#define JBD2_MAX_SLABS 8
>> +static struct kmem_cache *jbd2_slab[JBD2_MAX_SLABS];
>> +
>> +static const char *jbd2_slab_names[JBD2_MAX_SLABS] = {
>> +	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
>> +	"jbd2_16k", "jbd2_32k", "jbd2_64k", "jbd2_128k"
>> +};
>> +
>> +
>> +static void jbd2_journal_destroy_slabs(void)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < JBD2_MAX_SLABS; i++) {
>> +		if (jbd2_slab[i])
>> +			kmem_cache_destroy(jbd2_slab[i]);
>> +		jbd2_slab[i] = NULL;
>> +	}
>> +}
>> +
>> +static int jbd2_journal_create_slab(size_t size)
>> +{
>> +	int i = order_base_2(size) - 10;
>> +	size_t slab_size;
>> +
>> +	if (size == PAGE_SIZE)
>> +		return 0;
>> +
>> +	if (i >= JBD2_MAX_SLABS)
>> +		return -EINVAL;
>> +
>> +	if (unlikely(i < 0))
>> +		i = 0;
>> +	if (jbd2_slab[i])
>> +		return 0;	/* Already created */
>> +
>> +	slab_size = 1 << (i+10);
>> +	jbd2_slab[i] = kmem_cache_create(jbd2_slab_names[i], slab_size,
>> +					 slab_size, 0, NULL);
>> +	if (!jbd2_slab[i]) {
>> +		printk(KERN_EMERG "JBD2: no memory for jbd2_slab cache\n");
>> +		return -ENOMEM;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static struct kmem_cache *get_slab(size_t size)
>> +{
>> +	int i = order_base_2(size) - 10;
>> +
>> +	BUG_ON(i >= JBD2_MAX_SLABS);
>> +	if (unlikely(i < 0))
>> +		i = 0;
>> +	BUG_ON(jbd2_slab[i] == 0);
>> +	return jbd2_slab[i];
>> +}
>> +
>> +void *jbd2_alloc(size_t size, gfp_t flags)
>> +{
>> +	void *ptr;
>> +
>> +	BUG_ON(size & (size-1)); /* Must be a power of 2 */
>> +
>> +	flags |= __GFP_REPEAT;
>> +	if (size == PAGE_SIZE)
>> +		ptr = (void *)__get_free_pages(flags, 0);
>> +	else if (size > PAGE_SIZE) {
>> +		int order = get_order(size);
>> +
>> +		if (order < 3)
>> +			ptr = (void *)__get_free_pages(flags, order);
>> +		else
>> +			ptr = vmalloc(size);
>> +	} else
>> +		ptr = kmem_cache_alloc(get_slab(size), flags);
>> +
>> +	/* Check alignment; SLUB has gotten this wrong in the past,
>> +	 * and this can lead to user data corruption! */
>> +	BUG_ON(((unsigned long) ptr) & (size-1));
>> +
>> +	return ptr;
>> +}
>> +
>> +void jbd2_free(void *ptr, size_t size)
>> +{
>> +	if (size == PAGE_SIZE) {
>> +		free_pages((unsigned long)ptr, 0);
>> +		return;
>> +	}
>> +	if (size > PAGE_SIZE) {
>> +		int order = get_order(size);
>> +
>> +		if (order < 3)
>> +			free_pages((unsigned long)ptr, order);
>> +		else
>> +			vfree(ptr);
>> +		return;
>> +	}
>> +	kmem_cache_free(get_slab(size), ptr);
>> +};
>> +
>> +/*
>>  * Journal_head storage management
>>  */
>> static struct kmem_cache *jbd2_journal_head_cache;
>> @@ -2202,6 +2317,7 @@ static void jbd2_journal_destroy_caches(void)
>> 	jbd2_journal_destroy_revoke_caches();
>> 	jbd2_journal_destroy_jbd2_journal_head_cache();
>> 	jbd2_journal_destroy_handle_cache();
>> +	jbd2_journal_destroy_slabs();
>> }
>>
>> static int __init journal_init(void)
>> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
>> index f1011f7..a7a8c7a 100644
>> --- a/include/linux/jbd2.h
>> +++ b/include/linux/jbd2.h
>> @@ -69,15 +69,8 @@ extern u8 jbd2_journal_enable_debug;
>> #define jbd_debug(f, a...)	/**/
>> #endif
>>
>> -static inline void *jbd2_alloc(size_t size, gfp_t flags)
>> -{
>> -	return (void *)__get_free_pages(flags, get_order(size));
>> -}
>> -
>> -static inline void jbd2_free(void *ptr, size_t size)
>> -{
>> -	free_pages((unsigned long)ptr, get_order(size));
>> -};
>> +extern void *jbd2_alloc(size_t size, gfp_t flags);
>> +extern void jbd2_free(void *ptr, size_t size);
>>
>> #define JBD2_MIN_JOURNAL_BLOCKS 1024
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

