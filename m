From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on huge_file
Date: Fri, 10 Jul 2009 10:39:19 -0500
Message-ID: <4A5760A7.60607@redhat.com>
References: <6601abe90907100832q6ab886f2r7fc8e3be2a79e8e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZGJPjZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 11:39:25 -0400
In-Reply-To: <6601abe90907100832q6ab886f2r7fc8e3be2a79e8e5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Curt Wohlgemuth wrote:
> I apologize if this is a dumb question, but I'm having trouble
> understanding the huge_file superblock flag.
> 
> I see how, if this flag is set, that the inode can have a size > 2**32
> bytes, using the i_size_lo/i_size_high fields.
> 
> But since an ext4_extent only uses 32-bits for for its ee_block field
> to represent the logical block, how can an extent describe any block
> range of a file past the 4GiB boundary?
> 
> Am I missing something?

i_size_lo/hi is in bytes, ee_block is in .... blocks.

so 2^32 blocks is a lot more than 2^32 bytes, and i_size_hi/lo are
needed to contain it.  I think.  :)

-Eric
