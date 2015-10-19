From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: do not allow journal_opts for fs w/o journal
Date: Sun, 18 Oct 2015 23:57:35 -0400
Message-ID: <20151019035735.GS2678@thunk.org>
References: <1444381799-10566-1-git-send-email-dmonakhov@openvz.org>
 <1444381799-10566-2-git-send-email-dmonakhov@openvz.org>
 <04197994-C65B-4B52-9555-795E8B0B7E7B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58182 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbbJSD5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Oct 2015 23:57:37 -0400
Content-Disposition: inline
In-Reply-To: <04197994-C65B-4B52-9555-795E8B0B7E7B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 09, 2015 at 02:53:39PM -0600, Andreas Dilger wrote:
> On Oct 9, 2015, at 3:09 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > 
> > It is appeared that we can pass journal related mount options and such options
> > be shown in /proc/mounts
> > 
> > Example:
> > #mkfs.ext4 -F /dev/vdb
> > #tune2fs -O ^has_journal /dev/vdb
> > #mount /dev/vdb /mnt/  -ocommit=20,journal_async_commit
> > #cat /proc/mounts  | grep /mnt
> > /dev/vdb /mnt ext4 rw,relatime,journal_checksum,journal_async_commit,commit=20,data=ordered 0 0
> > 
> > But options:"journal_checksum,journal_async_commit,commit=20,data=ordered" has
> > nothing with reality because there is no jornall at all.
> 
> (typo) s/jornall/journal/
> 
> but looks reasonable otherwise.
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
