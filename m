From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] JBD: use GFP_NOFS  in kmalloc
Date: Wed, 19 Sep 2007 14:34:29 -0700
Message-ID: <20070919143429.ea0b37c9.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	<20070902152801.GA19962@infradead.org>
	<Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	<20070903134043.GB28962@infradead.org>
	<Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	<20070903193308.GA7771@infradead.org>
	<1189796027.3841.6.camel@localhost.localdomain>
	<1190057391.3845.22.camel@localhost.localdomain>
	<1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	<1190069851.6725.6.camel@localhost.localdomain>
	<20070918090407.GA671@infradead.org>
	<1190133347.3819.6.camel@localhost.localdomain>
	<1190138690.6528.23.camel@norville.austin.ibm.com>
	<1190163601.3819.15.camel@localhost.localdomain>
	<20070918191920.a2130a3c.akpm@linux-foundation.org>
	<1190229352.4318.12.camel@localhost.localdomain>
	<1190229729.4318.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbXISVfH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 17:35:07 -0400
In-Reply-To: <1190229729.4318.19.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 19 Sep 2007 12:22:09 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> Convert the GFP_KERNEL flag used in JBD/JBD2 to GFP_NOFS, consistent
> with the rest of kmalloc flag used in the JBD/JBD2 layer.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> ---
>  fs/jbd/journal.c  |    6 +++---
>  fs/jbd/revoke.c   |    8 ++++----
>  fs/jbd2/journal.c |    6 +++---
>  fs/jbd2/revoke.c  |    8 ++++----
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6.23-rc6/fs/jbd/journal.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/fs/jbd/journal.c	2007-09-19 11:51:10.000000000 -0700
> +++ linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-19 11:51:57.000000000 -0700
> @@ -653,7 +653,7 @@ static journal_t * journal_init_common (
>  	journal_t *journal;
>  	int err;
>  
> -	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
> +	journal = kmalloc(sizeof(*journal), GFP_NOFS);
>  	if (!journal)
>  		goto fail;
>  	memset(journal, 0, sizeof(*journal));
> @@ -723,7 +723,7 @@ journal_t * journal_init_dev(struct bloc
>  	journal->j_blocksize = blocksize;
>  	n = journal->j_blocksize / sizeof(journal_block_tag_t);
>  	journal->j_wbufsize = n;
> -	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
> +	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_NOFS);
>  	if (!journal->j_wbuf) {
>  		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
>  			__FUNCTION__);
> @@ -777,7 +777,7 @@ journal_t * journal_init_inode (struct i
>  	/* journal descriptor can store up to n blocks -bzzz */
>  	n = journal->j_blocksize / sizeof(journal_block_tag_t);
>  	journal->j_wbufsize = n;
> -	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
> +	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_NOFS);
>  	if (!journal->j_wbuf) {
>  		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
>  			__FUNCTION__);
> Index: linux-2.6.23-rc6/fs/jbd/revoke.c
> ===================================================================
> --- linux-2.6.23-rc6.orig/fs/jbd/revoke.c	2007-09-19 11:51:30.000000000 -0700
> +++ linux-2.6.23-rc6/fs/jbd/revoke.c	2007-09-19 11:52:34.000000000 -0700
> @@ -206,7 +206,7 @@ int journal_init_revoke(journal_t *journ
>  	while((tmp >>= 1UL) != 0UL)
>  		shift++;
>  
> -	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
> +	journal->j_revoke_table[0] = kmem_cache_alloc(revoke_table_cache, GFP_NOFS);
>  	if (!journal->j_revoke_table[0])
>  		return -ENOMEM;
>  	journal->j_revoke = journal->j_revoke_table[0];
> @@ -219,7 +219,7 @@ int journal_init_revoke(journal_t *journ
>  	journal->j_revoke->hash_shift = shift;
>  
>  	journal->j_revoke->hash_table =
> -		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
> +		kmalloc(hash_size * sizeof(struct list_head), GFP_NOFS);
>  	if (!journal->j_revoke->hash_table) {
>  		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
>  		journal->j_revoke = NULL;
> @@ -229,7 +229,7 @@ int journal_init_revoke(journal_t *journ
>  	for (tmp = 0; tmp < hash_size; tmp++)
>  		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
>  
> -	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
> +	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_NOFS);
>  	if (!journal->j_revoke_table[1]) {
>  		kfree(journal->j_revoke_table[0]->hash_table);
>  		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
> @@ -246,7 +246,7 @@ int journal_init_revoke(journal_t *journ
>  	journal->j_revoke->hash_shift = shift;
>  
>  	journal->j_revoke->hash_table =
> -		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
> +		kmalloc(hash_size * sizeof(struct list_head), GFP_NOFS);
>  	if (!journal->j_revoke->hash_table) {
>  		kfree(journal->j_revoke_table[0]->hash_table);
>  		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);

These were all OK using GFP_KERNEL.

GFP_NOFS should only be used when the caller is holding some fs locks which
might cause a deadlock if that caller reentered the fs in ->writepage (and
maybe put_inode and such).  That isn't the case in any of the above code,
which is all mount time stuff (I think).

ext3/4 should be using GFP_NOFS when the caller has a transaction open, has
a page locked, is holding i_mutex, etc.
