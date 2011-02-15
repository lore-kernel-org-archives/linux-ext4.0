From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: reserving code points for new ext4 quota
 feature
Date: Tue, 15 Feb 2011 12:07:13 -0500
Message-ID: <20110215170713.GF4255@thunk.org>
References: <AANLkTik3Ff7jokEL47uaLphwAP9hcd_16-eb3P8Cvagf@mail.gmail.com>
 <BD2A37BD-B970-4520-A8AB-589249C96755@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38833 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab1BORHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 12:07:15 -0500
Content-Disposition: inline
In-Reply-To: <BD2A37BD-B970-4520-A8AB-589249C96755@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 14, 2011 at 10:21:49PM -0700, Andreas Dilger wrote:
> This is missing the fact that ino 3 and 4 are already reserved for ACLs:
> 
> #define EXT2_ACL_IDX_INO         3      /* ACL inode */
> #define EXT2_ACL_DATA_INO        4      /* ACL inode */
> 
> That said, I don't know if those inodes are actually ever used,
> because the ACLs are stored in xattrs on each inode.

Nope, they were never used that for ACL's.  An early design used
separate ACL's to store the ACL's for the inodes, but eventually they
were implemented using extended attributes.

> In any case, the quota definitions should replace the ACL ones
> instead of being hidden after the main list (which is otherwise kept
> in numeric order).

Agreed.

						- Ted
