From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: e2fsprogs: debugfs: set_inode_field fails to set block[IND]...
Date: Mon, 18 Aug 2014 21:38:58 -0700
Message-ID: <20140819043858.GN2808@birch.djwong.org>
References: <CABW1wHSXSc-4kNDEzGKxPYTfust0Htc66VkcmoJVxrS-FA9Oog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Jun He <jhe@cs.wisc.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26484 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaHSEj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2014 00:39:26 -0400
Content-Disposition: inline
In-Reply-To: <CABW1wHSXSc-4kNDEzGKxPYTfust0Htc66VkcmoJVxrS-FA9Oog@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2014 at 11:32:10PM -0500, Jun He wrote:
> Hi,
> I hope this is the right place to report problems of e2fsprogs.
> 
> When trying to update block[IND], block[DIND], and block[TIND], it
> gives the similar error message:
> 
> jhe@node001:~$ sudo debugfs /dev/loop0 -w -R 'set_inode_field
> firstfile block[IND] 2'
> debugfs 1.42 (29-Nov-2011)
> set_inode_field: invalid field specifier: block[IND]
> 
> I looked at the code and found the problem in the following code in
> find_field() in debugfs/set_fields.c.
> 
>     idx = strchr(arg, '[');
>     if (idx) {
>         *idx++ = 0;
>         delim = idx + strlen(idx) - 1;
>         if (!*idx || *delim != ']')
>             idx = 0;
>         else
>             *delim = 0;
>     }
>     /*
>      * Can we parse the number?
>      */
>     if (idx) {
>         array_idx = strtol(idx, &tmp, 0);
>         if (*tmp)
>             idx = 0;
>     }
> 
> 
> When the field name is something like "block[4]", this works. It sets
> '[' and ']' to 0 and converts the number between them.
> When the field name is block[IND], it still replaces '[' and ']' with
> 0. So arg becomes 'block' and will always fail the following test of
>   if (strcmp(ss->name, arg) != 0).
> 
> One possible fix is to change the max limit for field 'block', use
> number to index IND, DIND, and TIND.
> Or, name 'block[IND]', 'block[DIND]', and 'block[TIND]' differently
> without the '[' ']'. Such as 'block.IND', 'block.DIND', 'block.TIND'.
> 
> If it's just a usage problem, please let me know how to use
> set_inode_field to set block[IND].. correctly.

Seems pretty broken to me.  I'll review any patch you send. :)

FWIW, I've been using modify_inode to mess with those fields.

Not that either command does much good for an extent files.

--D
> 
> Thanks,
> Jun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
