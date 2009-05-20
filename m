From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Wed, 20 May 2009 16:23:02 -0500
Message-ID: <4A1474B6.5000408@redhat.com>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz> <20090519174901.GB9053@mit.edu> <4A130022.6090807@redhat.com> <20090520113047.GC8684@one.firstfloor.org> <4A1426BE.2010101@redhat.com> <20090520160047.GI8684@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbZETVXJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2009 17:23:09 -0400
In-Reply-To: <20090520160047.GI8684@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andi Kleen wrote:
>> Just a one I guess:
>>
>> $ grep '^+' patch | grep 'KERN[_A-Z]\+[ $]'
>> +			ext3_msg(sb, KERN_ERR "(no)acl options not supported");
>> +	printk(KERN_INFO "EXT3-FS (%s): ", sb->s_id);
> 
> Ok thanks. Not sure how grep missed that one
> 
> Here's a updated patch with that fixed.
> 
> ---

Sorry, one more nitpick while I was comparing this to my ext4 patch
doing the same:


> @@ -1465,11 +1473,11 @@
>  #define PLURAL(x) (x), ((x)==1) ? "" : "s"
>  
>  	if (nr_orphans)
> -		printk(KERN_INFO "EXT3-fs: %s: %d orphan inode%s deleted\n",
> -		       sb->s_id, PLURAL(nr_orphans));
> +		ext3_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
> +			PLURAL(nr_orphans));
>  	if (nr_truncates)
> -		printk(KERN_INFO "EXT3-fs: %s: %d truncate%s cleaned up\n",
> -		       sb->s_id, PLURAL(nr_truncates));
> +		ext3_msg(sb, KERN_INFO, "%5d truncate%s cleaned up",
                                         ^^^ I doubt you wanted this :)

-Eric

> +		       PLURAL(nr_truncates));
>  #ifdef CONFIG_QUOTA
>  	/* Turn quotas off */
>  	for (i = 0; i < MAXQUOTAS; i++) {

