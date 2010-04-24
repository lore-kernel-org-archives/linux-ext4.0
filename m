From: tytso@mit.edu
Subject: Re: Question about e2fsck and HTree
Date: Fri, 23 Apr 2010 20:45:44 -0400
Message-ID: <20100424004544.GM14986@thunk.org>
References: <z2ne1e08eb01004221243m89a97acei72316abe62daaba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33572 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0DXApu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Apr 2010 20:45:50 -0400
Content-Disposition: inline
In-Reply-To: <z2ne1e08eb01004221243m89a97acei72316abe62daaba@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 22, 2010 at 11:43:30PM +0400, Evgeniy Ivanov wrote:
> Hello,
> 
> I have a question about ext2/ext3.
> 
> As I understand directory indexing is compatible feature, currently my
> implementations doesn't support HTree.
> I do some things (make kernel and libs) with FS and check it with
> e2fsck: it creates index (everything else is ok, exit status is 1).
> Then I do same things with FS and check again:
> 
> HTree directory inode 23316 has an invalid root node.
> 
> Is it OK for implementation without directory indexing?

If your implementation of extN don't support HTree, then it's
important that when you modify a filesystem you clear the inode's
EXT2_INDEX_FL flag.   Then the right thing will happen....

	      	      	       	     - Ted
