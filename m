From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH] ext4: don't split xattr inode refcounts across
 i_ctime and i_version fields
Date: Thu, 11 Jan 2018 13:39:14 -0500
Message-ID: <20180111183914.GE19241@thunk.org>
References: <20180109144701.27387-1-jlayton@kernel.org>
 <20180109185249.GA5594@magnolia>
 <1515524731.3571.16.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        dhowells@redhat.com
To: Jeff Layton <jlayton@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37634 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932215AbeAKSjV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 13:39:21 -0500
Content-Disposition: inline
In-Reply-To: <1515524731.3571.16.camel@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 09, 2018 at 02:05:31PM -0500, Jeff Layton wrote:
>
> Ahh, many thanks...
> 
> My main question was: why split the refcount across fields like this? If
> it's necessary now for backward compatibility then so be it, but it's
> weird and not 100% clear why it's being done that way.

The main reason is that the only inode that will need it is the hidden
extended attribute inode (and then only for Samba servers that are
supporting enterprise domain CIFS servers where there are more than
64k files using the same windows ACL).  So we didn't want to use extra
bytes in the inode, since it's only going to be used in a very tiny
fraction of servers.

For the right workload, though, this should allow ext4 to have
significantly better performance, since if you are serving a large
directory where all of the files have their own ACL or Windows
security ID xattrs, without shared extended attributes, when you open
a Files explorer on that directory, for each file the file system will
be forced to do lots of random 4k reads to fetch the xattrs.

   	     	     	       	  	- Ted
