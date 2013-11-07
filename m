From: Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH v2 01/11] rbtree: Fix rbtree_postorder_for_each_entry_safe()
 iterator
Date: Thu, 7 Nov 2013 03:51:04 -0800
Message-ID: <CANN689EhajVC4cq_oz2zaxOmMyYBZvGrKVsYYwkGH_C9jPGKag@mail.gmail.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
	<1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Seth Jennings <sjenning@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 6, 2013 at 5:42 PM, Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> From: Jan Kara <jack@suse.cz>
>
> The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
> underflow behavior when testing for loop termination. In particular
> it expects that
>   &rb_entry(NULL, type, field)->field
> is NULL. But the result of this expression is not defined by a C standard
> and some gcc versions (e.g. 4.3.4) assume the above expression can never
> be equal to NULL. The net result is an oops because the iteration is not
> properly terminated.
>
> Fix the problem by modifying the iterator to avoid pointer underflows.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/rbtree.h | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
> index aa870a4..57e75ae 100644
> --- a/include/linux/rbtree.h
> +++ b/include/linux/rbtree.h
> @@ -85,6 +85,11 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>         *rb_link = node;
>  }
>
> +#define rb_entry_safe(ptr, type, member) \
> +       ({ typeof(ptr) ____ptr = (ptr); \
> +          ____ptr ? rb_entry(____ptr, type, member) : NULL; \
> +       })
> +
>  /**
>   * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
>   * given type safe against removal of rb_node entry
> @@ -95,12 +100,9 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>   * @field:     the name of the rb_node field within 'type'.
>   */
>  #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
> -       for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
> -               n = rb_entry(rb_next_postorder(&pos->field), \
> -                       typeof(*pos), field); \
> -            &pos->field; \
> -            pos = n, \
> -               n = rb_entry(rb_next_postorder(&pos->field), \
> -                       typeof(*pos), field))
> +       for (pos = rb_entry_safe(rb_first_postorder(root), typeof(*pos), field); \
> +            pos && ({ n = rb_entry_safe(rb_next_postorder(&pos->field), \
> +                       typeof(*pos), field); 1; }); \
> +            pos = n)
>
>  #endif /* _LINUX_RBTREE_H */
> --
> 1.8.4.2

Well, this really isn't pretty, and I'm not sure that
rbtree_postorder_for_each_entry_safe() is a good idea in the first
place. Note that we have never had or needed such a macro for the
common case of in-order iteration; why would we need it for the
less-common case of postorder iteration ?

I think it's just as well to have clients write something like
struct rb_node *rb_node = rb_first_postorder(root);
while (rb_node) {
    struct rb_node *rb_next_node = rb_next_postorder(rb_node);
    struct mystruct node = rb_entry(rb_node, struct mystruct,
mystruct_rb_field);
    .... do whatever, possibly destroying node ...
    rb_node = rb_next_node;
}

That said, there is some precedent for this kind of API in
hlist_for_each_entry_safe, so I guess that's acceptable if there will
be enough users of this macro - but it seems very strange to me that
we would need it for the postorder traversal while we don't for the
in-order traversal. I would prefer keeping rbtree.h minimal if that is
possible.

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
