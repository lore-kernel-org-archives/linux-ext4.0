From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [RFC PATCH] ext4: don't split xattr inode refcounts across
 i_ctime and i_version fields
Date: Thu, 11 Jan 2018 15:09:03 -0500
Message-ID: <1515701343.3788.19.camel@kernel.org>
References: <20180109144701.27387-1-jlayton@kernel.org>
         <20180109185249.GA5594@magnolia> <1515524731.3571.16.camel@kernel.org>
         <20180111183914.GE19241@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        dhowells@redhat.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932419AbeAKUJF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 15:09:05 -0500
In-Reply-To: <20180111183914.GE19241@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2018-01-11 at 13:39 -0500, Theodore Ts'o wrote:
> On Tue, Jan 09, 2018 at 02:05:31PM -0500, Jeff Layton wrote:
> > 
> > Ahh, many thanks...
> > 
> > My main question was: why split the refcount across fields like this? If
> > it's necessary now for backward compatibility then so be it, but it's
> > weird and not 100% clear why it's being done that way.
> 
> The main reason is that the only inode that will need it is the hidden
> extended attribute inode (and then only for Samba servers that are
> supporting enterprise domain CIFS servers where there are more than
> 64k files using the same windows ACL).  So we didn't want to use extra
> bytes in the inode, since it's only going to be used in a very tiny
> fraction of servers.
> 
> For the right workload, though, this should allow ext4 to have
> significantly better performance, since if you are serving a large
> directory where all of the files have their own ACL or Windows
> security ID xattrs, without shared extended attributes, when you open
> a Files explorer on that directory, for each file the file system will
> be forced to do lots of random 4k reads to fetch the xattrs.
> 

Oh, sorry...I may not have been clear.

I wasn't really asking about the need for xattr inodes. My question was
more about why it was decided to split the refcount in two, and store
part of it in the ctime and part in the i_version field.

Wouldn't it have made more sense to just store it all in i_version field
(like this patch makes it do)? If this breaks backward compatibility
though, then I'm fine with just dropping the patch.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
