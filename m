From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 2 Mar 2007 14:41:01 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703021439360.23355@yvahk01.tjqt.qr>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
 <20070225022326.137b4875.akpm@linux-foundation.org>
 <20070301183445.GA7911@amitarora.in.ibm.com>  <20070301142537.b5950cd7.akpm@linux-foundation.org>
  <1172789056.11165.42.camel@kleikamp.austin.ibm.com>
 <20070301145949.3efac328.akpm@linux-foundation.org>
 <1172790570.11165.62.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:33256 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992435AbXCBNzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 08:55:19 -0500
In-Reply-To: <1172790570.11165.62.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Mar 1 2007 23:09, Dave Kleikamp wrote:
>> 
>> Given that glibc already implements fallocate for all filesystems, it will
>> need to continue to do so for filesystems which don't implement this
>> syscall - otherwise applications would start breaking.
>
>I didn't make it clear, but my point was to call generic_fallocate if
>the file system did not define i_op->allocate().
>
>if (inode->i_op && inode->i_op->fallocate)
>	ret = inode->i_op->fallocate(inode, offset, len);
>else
>	ret = generic_fallocate(inode, offset, len);
>
>I'm not sure it's worth the effort, but I thought I'd throw the idea out
>there.

Writing zeroes using glibc emu most likely means write() --
so generic_fallocate should be preferable (think splice).
Or does glibc use mmap() and it's all different?


Jan
-- 
