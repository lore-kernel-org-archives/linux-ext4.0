From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Thu, 24 Feb 2011 14:57:40 +0100
Message-ID: <20110224135740.GF23042@quack.suse.cz>
References: <4D5ED705.7010902@redhat.com>
 <20110221134642.GC6584@quack.suse.cz>
 <4D629C78.60600@redhat.com>
 <20110223173152.GM2924@thunk.org>
 <20110224114914.GD23042@quack.suse.cz>
 <4688CF7A-2859-465B-B0EC-B4E31800E5F2@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1BXN5m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 08:57:42 -0500
Content-Disposition: inline
In-Reply-To: <4688CF7A-2859-465B-B0EC-B4E31800E5F2@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 24-02-11 07:19:46, Theodore Tso wrote:
> 
> On Feb 24, 2011, at 6:49 AM, Jan Kara wrote:
> 
> >  I agree it may cause surprises although it's not true that ACL's remove
> > rights. Rather on contrary ACL's can only give additional rights (i.e. you
> > have 600 file + user foo can also read it) thus noacl->acl transition might
> > be insecure if you have some old unwanted ACL's pending.
> 
> My understanding of how POSIX acls work is that the if you want to give
> read access to user "foo" (where "foo" is not the user) is you first have to 
> open up the file permissions to do the equivalent of "o+r".
  I've actually tried that before posting my email and it's not like that.
I did:
jack@quack:~/source> echo 'aaa' >/tmp/f
jack@quack:~/source> chmod 600 /tmp/f
jack@quack:~/source> setfacl -m u:nobody:rw /tmp/f
jack@quack:~/source> sudo su nobody -c "cat /tmp/f"
aaa
jack@quack:~/source> sudo su news -c "cat /tmp/f"
cat: /tmp/f: Permission denied

> See: http://acl.bestbits.at/man/man5/acl.txt
> 
> And then note how ACL_MASK corresponds to the permissions bits...
  OK, I see but then look at setfactl(1), commentary of -n option:
The default  behavior of  setfacl  is  to  recalculate  the ACL mask entry,
unless a mask entry was explicitly given.  The mask entry is set to the
union of all  permissions  of the owning group, and all named user and
group entries. (These are  exactly  the  entries  affected  by  the mask
entry).

  So setfacl(1) by default makes the mask logic void.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
