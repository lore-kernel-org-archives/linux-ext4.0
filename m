From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] rbtree: fix postorder iteration when the rb_node
 is not the first element in an entry
Date: Wed, 06 Nov 2013 12:18:32 -0800
Message-ID: <527AA418.7010009@linux.vnet.ibm.com>
References: <52784ADF.1040104@linux.vnet.ibm.com> <1383615602-1784-1-git-send-email-cody@linux.vnet.ibm.com> <5278C2F8.3050805@linux.vnet.ibm.com> <20131105215755.GB9236@quack.suse.cz> <20131105225619.GC9236@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	LKML <linux-kernel@vger.kernel.org>,
	EXT4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131105225619.GC9236@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/05/2013 02:56 PM, Jan Kara wrote:
> On Tue 05-11-13 22:57:55, Jan Kara wrote:
>> >On Tue 05-11-13 02:05:44, Cody P Schafer wrote:
>>> > >On 11/04/2013 05:40 PM, Cody P Schafer wrote:
>>>> > > >Provide a new helper called rb_next_postorder_entry() to perform NULL
>>>> > > >checks and container_of() coversions and use it in
>>>> > > >rbtree_for_each_entry_safe() to fix oopses that occur when rb_node is
>>>> > > >not the first element in the entry.
>>> > >
>>> > >On second thought, it appears I was a bit to hasty with this, and this patch actually breaks things.
>>> > >
>>> > >On 11/04/2013 04:45 PM, Jan Kara wrote:> On Mon 04-11-13 15:26:38, Jan Kara wrote:
>>>>> > > >>On Fri 01-11-13 15:38:50, Cody P Schafer wrote:
>>>>>> > > >>>Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
>>>>>> > > >>>of opencoding an alternate postorder iteration that modifies the tree
>>>>> > > >>    Thanks. I've merged the patch into my tree.
>>>> > > >    Hum, except that the kernel oopses with this patch.
>>> > >
>>> > >No, it shouldn't oops because pos won't be NULL, &pos->field will be.
>>> > >
>> >   OK, so I had a second look. And the compiler thinks differently than you
>> >:)  The thing is that my gcc (4.3.4) apparently assumes pointer underflow is
>> >undefined and thus optimizes your test &pos->field to 1. I've asked our gcc
>> >guys for a definitive answer but clearly your code will need some way to
>> >avoid pointer underflows...
>    I've just now checked how e.g. hlist iterators solve similar problem and
> modified the rbtree iterator accordingly. The patch is attached and with it
> and your ext3 patch my test machine is able to boot again.
>
> 								Honza

That looks good, thanks.

I've thrown together a basic runtime test for the 
rbtree_postorder_for_each_entry_safe() macro, will send that out shortly.

For the record with my gcc (gcc version 4.6.4 (Ubuntu/Linaro 
4.6.4-1ubuntu1~12.04)) I can't get it to bug out (even when your fix 
_isn't_ applied).

>
> 0001-rbtree-Fix-rbtree_postorder_for_each_entry_safe-i.patch
>
>
>  From d51a16626d241ded8913768d6f24484b1d4335ba Mon Sep 17 00:00:00 2001
> From: Jan Kara<jack@suse.cz>
> Date: Tue, 5 Nov 2013 21:39:48 +0100
> Subject: [PATCH] rbtree: Fix rbtree_postorder_for_each_entry_safe() iterator
>
> The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
> underflow behavior when testing for loop termination. In particular
> it expects that
>    &rb_entry(NULL, type, field)->field
> is NULL. But the result of this expression is not defined by a C standard
> and some gcc versions (e.g. 4.3.4) assume the above expression can never
> be equal to NULL. The net result is an oops because the iteration is not
> properly terminated.
>
> Fix the problem by modifying the iterator to avoid pointer underflows.
>
> Signed-off-by: Jan Kara<jack@suse.cz>
> ---
>   include/linux/rbtree.h |   16 +++++++++-------
>   1 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
> index aa870a4..57e75ae 100644
> --- a/include/linux/rbtree.h
> +++ b/include/linux/rbtree.h
> @@ -85,6 +85,11 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>   	*rb_link = node;
>   }
>
> +#define rb_entry_safe(ptr, type, member) \
> +	({ typeof(ptr) ____ptr = (ptr); \
> +	   ____ptr ? rb_entry(____ptr, type, member) : NULL; \
> +	})
> +
>   /**
>    * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
>    * given type safe against removal of rb_node entry
> @@ -95,12 +100,9 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>    * @field:	the name of the rb_node field within 'type'.
>    */
>   #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
> -	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
> -		n = rb_entry(rb_next_postorder(&pos->field), \
> -			typeof(*pos), field); \
> -	     &pos->field; \
> -	     pos = n, \
> -		n = rb_entry(rb_next_postorder(&pos->field), \
> -			typeof(*pos), field))
> +	for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
> +	     pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
> +			typeof(*pos), field); 1; }); \
> +	     pos = n)
>
>   #endif	/* _LINUX_RBTREE_H */
> -- 1.6.0.2
>
