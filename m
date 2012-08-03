From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Use fsck to free the space used by dir?
Date: Fri, 3 Aug 2012 13:57:27 -0400
Message-ID: <20120803175727.GB8463@thunk.org>
References: <501BDDE5.8060005@gmail.com>
 <501BEBE1.5080508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Sheng-Hui <shhuiw@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42839 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2HCR5b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2012 13:57:31 -0400
Content-Disposition: inline
In-Reply-To: <501BEBE1.5080508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 03, 2012 at 10:18:57AM -0500, Eric Sandeen wrote:
> On 8/3/12 9:19 AM, Wang Sheng-Hui wrote:
> > Dear all,
> > 
> > I read through the namei.c code recently, but didn't notice any code to
> > reduce the size of a dir file (append can increase its size though).
> 
> Right, AFAIK nothing in kernelspace will reduce the size.

In theory, if the dir_index (htree) support is enabled, it would be
possible for the kernel to reorganize the directory dynamically.  

If dir_index is not enabled, reorganizing the directory would would
break any open readdir() sessions and any NFS server file handles.
(Which means if the file system has been exported by NFS in the past,
and expects to be exported by NFS in the future, reorg'ing a directory
will seriously confuse any clients which have cached NFS handles.)

For that reason, historically we've never bothered to try to implement
ways of decreasing the size of a directory --- especially since in
most cases, sysadmins can do something like:

mkdir foo.new ; mv foo/* foo.new ; mv foo.new foo

which while isn't perfect, works most of the time.

Regards,

						- Ted
