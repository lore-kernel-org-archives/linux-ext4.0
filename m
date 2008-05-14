From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: printk stack trace on ext4_error, ext4_abort and
 ext4_warning.
Date: Wed, 14 May 2008 14:07:14 -0500
Message-ID: <482B3862.6040809@redhat.com>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763125AbYENTIV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 May 2008 15:08:21 -0400
In-Reply-To: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> This helps in better debugging of the problem reported.

ext4_error happens potentially often in some scenarios, and if I chose
errors=continue I'm not sure I'd want to dump this much.

Would it be worth limiting how often this goes off (maybe just once per fs?)

-Eric


> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index cd7cac0..93f4820 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -238,6 +238,7 @@ void ext4_error (struct super_block * sb, const char * function,
>  	vprintk(fmt, args);
>  	printk("\n");
>  	va_end(args);
> +	dump_stack();
>  
>  	ext4_handle_error(sb);
>  }
> @@ -320,6 +321,7 @@ void ext4_abort (struct super_block * sb, const char * function,
>  	vprintk(fmt, args);
>  	printk("\n");
>  	va_end(args);
> +	dump_stack();
>  
>  	if (test_opt(sb, ERRORS_PANIC))
>  		panic("EXT4-fs panic from previous error\n");
> @@ -345,6 +347,7 @@ void ext4_warning (struct super_block * sb, const char * function,
>  	vprintk(fmt, args);
>  	printk("\n");
>  	va_end(args);
> +	dump_stack();
>  }
>  
>  void ext4_update_dynamic_rev(struct super_block *sb)

