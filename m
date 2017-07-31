From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/11] ext4: Don't clear SGID when inheriting ACLs
Date: Sun, 30 Jul 2017 23:34:06 -0400
Message-ID: <20170731033406.ls7hrmaj6hdafxgm@thunk.org>
References: <20170622133115.16968-1-jack@suse.cz>
 <20170622133115.16968-2-jack@suse.cz>
 <20170718161631.GA27293@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47292 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbdGaDeL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Jul 2017 23:34:11 -0400
Content-Disposition: inline
In-Reply-To: <20170718161631.GA27293@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 06:16:31PM +0200, Jan Kara wrote:
> On Thu 22-06-17 15:31:05, Jan Kara wrote:
> > When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> > set, DIR1 is expected to have SGID bit set (and owning group equal to
> > the owning group of 'DIR0'). However when 'DIR0' also has some default
> > ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> > 'DIR1' to get cleared if user is not member of the owning group.
> > 
> > Fix the problem by moving posix_acl_update_mode() out of
> > __ext4_set_acl() into ext4_set_acl(). That way the function will not be
> > called when inheriting ACLs which is what we want as it prevents SGID
> > bit clearing and the mode has been properly set by posix_acl_create()
> > anyway.
> > 
> > Fixes: 073931017b49d9458aa351605b43a7e34598caef
> > CC: stable@vger.kernel.org
> > CC: linux-ext4@vger.kernel.org
> > CC: "Theodore Ts'o" <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Ted, can you please pick up this fix? Thanks!

Thanks, applied.

						- Ted
