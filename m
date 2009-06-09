From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -V2 2/2] ext4: truncate the file properly if we fail to
	copy data from userspace
Date: Tue, 9 Jun 2009 12:12:54 +0200
Message-ID: <20090609101254.GA9235@duck.suse.cz>
References: <20090605234458.GG11650@duck.suse.cz> <1244435715-6807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244435715-6807-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090608162959.GJ23883@mit.edu> <20090608164357.GA23723@skywalker> <20090608191420.GM23883@mit.edu> <20090608202049.GC23723@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54813 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbZFIKMz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:12:55 -0400
Content-Disposition: inline
In-Reply-To: <20090608202049.GC23723@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-06-09 01:50:49, Aneesh Kumar K.V wrote:
> On Mon, Jun 08, 2009 at 03:14:20PM -0400, Theodore Tso wrote:
> > On Mon, Jun 08, 2009 at 10:13:57PM +0530, Aneesh Kumar K.V wrote:
> > > I think i both the case Jan's patch
> > > allocate-blocks-correctly-with-subpage-blocksize need an update ? Since you have put
> > > the patch before Jan's changes.
> > 
> > OK, here's how I updated Jan's patch.  I'm going to assume that we'll
> > submit the ext4 patch queue immediately as soon as the merge window
> > opens, since my impression is Jan is still waiting for some mm
> > developers to review his patch set.   
> > 
> > Annesh, does this look good to you?
> 
> I just did a quick look. Should we do a block_unlock_hole_extend after
> journal_stop. We do a block_lock_hole_extend before journal_start.
  Well, it's not really necessary (and it was not like that in my original
patch). You just have to do it after i_size has been updated and the
function just needs to acquire inode_lock spinlock so there's no risk of
deadlock anywhere...

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
