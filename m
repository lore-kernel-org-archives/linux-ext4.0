From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Remove ext4 xattr mbcache to fix CPU lockup when using
 ceph #107301
Date: Fri, 20 Nov 2015 23:22:08 -0500
Message-ID: <20151121042208.GC350@thunk.org>
References: <1448012628.1905.253.camel@guerby.net>
 <DD9C7131-404D-4873-A240-349F4E34E2BD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laurent GUERBY <laurent@guerby.net>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sage@redhat.com" <sage@redhat.com>,
	Abaakouk Mehdi <sileht@sileht.net>,
	Loic Dachary <loic@dachary.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44061 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbbKUEWa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Nov 2015 23:22:30 -0500
Content-Disposition: inline
In-Reply-To: <DD9C7131-404D-4873-A240-349F4E34E2BD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 20, 2015 at 06:08:15PM -0700, Andreas Dilger wrote:
> 
> I'm definitely not in favor of deleting mbcache entirely, just having the
> mount option to disable it in cases where it is known not to be useful,
> such as Ceph or Lustre backing stores that never have shared xattrs.
> 
> In some cases mbcache can be useful, since it allows sharing xattrs
> between inodes. 
> 
> I thought you would update our patch to add the mount option to disable
> mbcache?

And better yet would be if there was a blacklist of Lustre and Ceph
xattr type/keys that will never have shared attrs, so that mbcache is
not used for those xattrs automatically, *without* using a mount
option.  Can someone at least start help creating that list?

But yeah, a complete deletion of mbcache is a non-starter.

Regards,

						- Ted
