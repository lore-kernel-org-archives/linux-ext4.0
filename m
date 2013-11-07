From: Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH v2 03/11] rbtree/test: test rbtree_postorder_for_each_entry_safe()
Date: Thu, 7 Nov 2013 03:54:05 -0800
Message-ID: <CANN689FAXMHtBpcXJ2ATuG66Q5BihQJu=hW-Lm14GC7OtSChLw@mail.gmail.com>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
	<1383788572-25938-4-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
	Seth Jennings <sjenning@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f46.google.com ([209.85.128.46]:42080 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3KGLyH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Nov 2013 06:54:07 -0500
Received: by mail-qe0-f46.google.com with SMTP id s14so304640qeb.33
        for <linux-ext4@vger.kernel.org>; Thu, 07 Nov 2013 03:54:05 -0800 (PST)
In-Reply-To: <1383788572-25938-4-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 6, 2013 at 5:42 PM, Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  lib/rbtree_test.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/lib/rbtree_test.c b/lib/rbtree_test.c
> index df6c125..8b3c9dc 100644
> --- a/lib/rbtree_test.c
> +++ b/lib/rbtree_test.c
> @@ -114,6 +114,16 @@ static int black_path_count(struct rb_node *rb)
>         return count;
>  }
>
> +static void check_postorder_foreach(int nr_nodes)
> +{
> +       struct test_node *cur, *n;
> +       int count = 0;
> +       rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
> +               count++;
> +
> +       WARN_ON_ONCE(count != nr_nodes);
> +}
> +
>  static void check_postorder(int nr_nodes)
>  {
>         struct rb_node *rb;
> @@ -148,6 +158,7 @@ static void check(int nr_nodes)
>         WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
>
>         check_postorder(nr_nodes);
> +       check_postorder_foreach(nr_nodes);
>  }
>
>  static void check_augmented(int nr_nodes)
> --
> 1.8.4.2

Looks reasonable if we need the rbtree_postorder_for_each_entry_safe
macro - but as I mentioned in 01/11, I would prefer if we could do
without that API.

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
