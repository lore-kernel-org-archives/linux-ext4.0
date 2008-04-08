From: Nathan Grennan <jack@cygnusx-1.org>
Subject: Re: Ordered mode rewrite patch
Date: Tue, 08 Apr 2008 13:12:20 -0700
Message-ID: <47FBD1A4.80606@cygnusx-1.org>
References: <20080408121149.GB6901@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from okcforum.org ([69.17.49.173]:51050 "EHLO mail.okcforum.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYDHUV3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2008 16:21:29 -0400
In-Reply-To: <20080408121149.GB6901@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   Hello,
>
>   attached is a jumbo patch that reverses locking order of transaction
> start and page lock in ext3 and rewrites handling of ordered data mode in
> JBD and ext3. Note that the patch will break compilation of ext4 and OCFS2.
> The patch survives LTP run on my test machine so it shouldn't eat your data
> immediately but bugs are of course possible...
>   I'm very interested in any results (both positive and negative) you could
> get with it :). Thanks for testing it.
>
> 									Honza
>
> PS: CCing also linux-ext4 list in case there are some other interested
> testers. Next on my todo list is to port this for ext4...
>   
I am trying to apply the patch to Fedora 8's kernel-2.6.24.4-64, and it 
fails on all the files.

+ '[' '!' -f 
/home/builder/rpmbuild/SOURCES/kernel-2.6.24.4/ext3-jbd-2.6.25-ordered_mode.patch 
']'
+ case "$patch" in
+ patch -p1 -F1 -s
1 out of 26 hunks FAILED -- saving rejects to file fs/ext3/inode.c.rej
1 out of 11 hunks FAILED -- saving rejects to file fs/jbd/commit.c.rej
1 out of 12 hunks FAILED -- saving rejects to file fs/jbd/transaction.c.rej
1 out of 1 hunk FAILED -- saving rejects to file 
include/linux/writeback.h.rej

