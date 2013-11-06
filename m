From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rbtree/test: test
 rbtree_postorder_for_each_entry_safe()
Date: Wed, 6 Nov 2013 15:16:04 -0800
Message-ID: <20131106151604.c2f85c3463e663cc27fd4eaf@linux-foundation.org>
References: <527AA418.7010009@linux.vnet.ibm.com>
	<1383773843-19981-1-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	EXT4 <linux-ext4@vger.kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383773843-19981-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed,  6 Nov 2013 13:37:23 -0800 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> ...
>
> --- a/lib/rbtree_test.c
> +++ b/lib/rbtree_test.c
> @@ -114,6 +114,16 @@ static int black_path_count(struct rb_node *rb)
>  	return count;
>  }
>  
> +static void check_postorder_foreach(int nr_nodes)
> +{
> +	struct test_node *cur, *n;
> +	int count = 0;
> +	rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
> +		count++;
> +
> +	WARN_ON_ONCE(count != nr_nodes);
> +}
> +
>  static void check_postorder(int nr_nodes)
>  {
>  	struct rb_node *rb;
> @@ -148,6 +158,7 @@ static void check(int nr_nodes)
>  	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
>  
>  	check_postorder(nr_nodes);
> +	check_postorder_foreach(nr_nodes);
>  }
>  
>  static void check_augmented(int nr_nodes)

I'm rather confused about where this fits with the other (and
apparently withdrawn) patches.

Please resend everything?
