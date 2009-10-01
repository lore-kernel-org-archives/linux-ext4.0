From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 3/3][RFC](Repost) ext4: add a message in remount/umount
 for ext4
Date: Thu, 01 Oct 2009 13:32:31 +0900
Message-ID: <4AC430DF.5040505@jp.fujitsu.com>
References: <20090930154931.ef2a4760.toshi.okajima@jp.fujitsu.com> <20090930172220.GL24383@mit.edu> <4AC41FF1.7060703@jp.fujitsu.com> <20091001035544.GT24383@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger@sun.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46553 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZJAEcd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Oct 2009 00:32:33 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n914Wacq016874
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Thu, 1 Oct 2009 13:32:36 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 9EF7445DE51
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 13:32:36 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 7F3CD45DE4E
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 13:32:36 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6197D1DB803C
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 13:32:36 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1A22E1DB803B
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2009 13:32:36 +0900 (JST)
In-Reply-To: <20091001035544.GT24383@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
thank you for your comment.

Theodore Tso wrote:
> On Thu, Oct 01, 2009 at 12:20:17PM +0900, Toshiyuki Okajima wrote:
>> I am recognizing it. But I think I have already explained its answer as follows:
>>  - A print mechanism has already been included at mount time.
> 
> It's true that some file systems already are printing a message at
> mount time; but when we abstract up something to the VFS layer, that's
> also an opportunity to remove some kernel printk's from some
> filesystems, including ext2/3/4 at the same time this feature is
> introduced.
> 
>>> filesystem specific information, but that could be handled via a new
>>> method function in struct super_ops:
>>>
>>>        mount_msg(struct super *sb, char *buf, int buflen)
>>>
> 
> Note that what I was assuming is that we would is something like this
> in the VFS mount code:
> 
>      printk(KERN_INFO "Device %s mounted file system type %s read-%s%s\n",
>             sb->s_sid, sb->s_type->name, 
> 	    sb->s_flags & MS_RDONLY ? "only" : "write",
> 	    sb->s_op->mount_msg ? sb->s_op->mount_msg(sb) : "");
> 
> The advantage of this is that we would now have a single consistent
> kernel message for all file systems, with some room for file system
> specific message.
OK.

I try to implement the message mechanism at mount/umount time like
your description ASAP.

Best Regards,
Toshiyuki Okajima

