From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 01/11] rbtree: Fix rbtree_postorder_for_each_entry_safe()
 iterator
Date: Thu, 07 Nov 2013 10:59:27 -0800
Message-ID: <527BE30F.7090108@linux.vnet.ibm.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com> <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com> <CANN689EhajVC4cq_oz2zaxOmMyYBZvGrKVsYYwkGH_C9jPGKag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Seth Jennings <sjenning@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
To: Michel Lespinasse <walken@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44484 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3KGS7n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 13:59:43 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <cody@linux.vnet.ibm.com>;
	Thu, 7 Nov 2013 13:59:42 -0500
In-Reply-To: <CANN689EhajVC4cq_oz2zaxOmMyYBZvGrKVsYYwkGH_C9jPGKag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/07/2013 03:51 AM, Michel Lespinasse wrote:
> On Wed, Nov 6, 2013 at 5:42 PM, Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>> From: Jan Kara <jack@suse.cz>

[...]
>>
>> +#define rb_entry_safe(ptr, type, member) \
>> +       ({ typeof(ptr) ____ptr = (ptr); \
>> +          ____ptr ? rb_entry(____ptr, type, member) : NULL; \
>> +       })
>> +
>>   /**
>>    * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
>>    * given type safe against removal of rb_node entry
>> @@ -95,12 +100,9 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>>    * @field:     the name of the rb_node field within 'type'.
>>    */
>>   #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \

[...]
>> +       for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
>> +            pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
>> +                       typeof(*pos), field); 1; }); \
>> +            pos = n)

>
> Well, this really isn't pretty, and I'm not sure that
> rbtree_postorder_for_each_entry_safe() is a good idea in the first
> place. Note that we have never had or needed such a macro for the
> common case of in-order iteration; why would we need it for the
> less-common case of postorder iteration ?

Well, maybe we should add a helper for in-order iteration if it 
simplifies the code's appearance significantly. I added this one because 
I think it's highly probable that users of the postorer iteration will 
always want the *_entry_safe() style for_each, meaning I don't have to 
add the other (non-safe, non-entry) variants.

> I think it's just as well to have clients write something like
> struct rb_node *rb_node = rb_first_postorder(root);
> while (rb_node) {
>      struct rb_node *rb_next_node = rb_next_postorder(rb_node);
>      struct mystruct *node = rb_entry(rb_node, struct mystruct,
> mystruct_rb_field);
>      .... do whatever, possibly destroying node ...
>      rb_node = rb_next_node;
> }
>

So, 4 extra lines per usage, an extra variable, and the need to split 
the iteration's logic across the action performed.

> That said, there is some precedent for this kind of API in
> hlist_for_each_entry_safe, so I guess that's acceptable if there will
> be enough users of this macro - but it seems very strange to me that
> we would need it for the postorder traversal while we don't for the
> in-order traversal. I would prefer keeping rbtree.h minimal if that is
> possible.
>

The other patches in this patchset add 16 usages of the for_each macro, 
and these are only conversions of the simple cases I found by grepping 
the kernel for rb_erase() and rb_(left|right) = NULL patterns. I others 
have found other ways to do the same (or similar) things that I haven't 
noticed.

