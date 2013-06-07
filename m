From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: detect invalid extents at the end of an extent-block
Date: Thu, 06 Jun 2013 22:40:37 -0500
Message-ID: <51B15635.1000406@redhat.com>
References: <20130403190841.GA16276@fury.redhat.com> <51AE45CF.6070901@redhat.com> <20130607033508.GA7555@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: David Jeffery <djeffery@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab3FGDkk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jun 2013 23:40:40 -0400
In-Reply-To: <20130607033508.GA7555@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/6/13 10:35 PM, Theodore Ts'o wrote:
> On Tue, Jun 04, 2013 at 02:53:51PM -0500, Eric Sandeen wrote:
>>
>> Here's an image which demonstrates this, current e2fsck does not detect
>> the error.
> 
> Thanks.  For future reference, here's how you can use debugfs to
> generate a much smaller image which demonstrates the problem, suitable
> for use in a regression test.

Ah.  Well, I did use debugfs to make it, but not quite so compactly.  :)

Thanks,
-Eric

> 					- Ted
> 
> #!/bin/sh
> dd if=/dev/zero of=image bs=1k count=256
> mke2fs -Ft ext4 image
> debugfs -w image << EOF
> write /dev/null testfile
> extent_open testfile
>   insert_node 0 15 100
>   insert_node --after 15 15 115
>   insert_node --after 30 15 130
>   insert_node --after 45 15 145
>   split
>   down
>   split
>   root
>   down
>   next
>   replace_node 15 30 200
>   extent_close
> set_inode_field testfile i_size 61400
> set_inode_field testfile i_blocks 154
> setb 100 15
> setb 130 30
> setb 200 30
> set_bg 0 free_blocks_count 156
> set_bg 0 bg_checksum calc
> set_super_value free_blocks_count 156
> EOF
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

