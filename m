From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Wed, 28 Mar 2012 12:15:49 +0200
Message-ID: <20120328101549.GB18751@quack.suse.cz>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322095342.GC14485@quack.suse.cz>
 <1332410747.18717.12.camel@sauron.fi.intel.com>
 <20120322103309.GA14484@quack.suse.cz>
 <1332854998.31549.40.camel@sauron.fi.intel.com>
 <20120327201401.GF5020@quack.suse.cz>
 <1332924282.31549.51.camel@sauron.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab2C1KQF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2012 06:16:05 -0400
Content-Disposition: inline
In-Reply-To: <1332924282.31549.51.camel@sauron.fi.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 28-03-12 11:44:42, Artem Bityutskiy wrote:
> On Tue, 2012-03-27 at 22:14 +0200, Jan Kara wrote:
> > @@ -181,9 +181,22 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
> >                 path.dentry = mnt->mnt_root;
> >                 cp = d_path(&path, buf, sizeof(buf));
> >                 if (!IS_ERR(cp)) {
> > +                       handle_t *handle;
> > +                       int err;
> > +
> > +                       handle = ext4_journal_start_sb(sb, 1);
> > +                       if (IS_ERR(handle))
> > +                               return PTR_ERR(handle);
> > +                       err = ext4_journal_get_write_access(handle,
> > +                                                           EXT4_SB(sb)->s_sbh);
> 
> Why do we need to bother with journal in this case - AFAIU, we update a
> single field, not critical, and we do not really need the journal for
> this - we can just call 'mark_buffer_dirty(sbi->s_sbh)' and let the SB
> be written out directly and asynchronously.
  Well, except that if someone is trying to modify the superblock via the
journal in parallel, the journalling layer will loudly complain about
buffer becoming dirty under it's hands... So there are only two ways you
can reasonably do this in ext3/ext4 - just modify the data (which is a bit
ugly but works), or do full journalling.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
