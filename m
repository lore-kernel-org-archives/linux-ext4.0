From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Thu, 24 Feb 2011 19:31:26 +0100
Message-ID: <20110224183126.GI23042@quack.suse.cz>
References: <4D5ED705.7010902@redhat.com>
 <20110221134642.GC6584@quack.suse.cz>
 <4D629C78.60600@redhat.com>
 <20110223173152.GM2924@thunk.org>
 <20110224114914.GD23042@quack.suse.cz>
 <4688CF7A-2859-465B-B0EC-B4E31800E5F2@mit.edu>
 <20110224135740.GF23042@quack.suse.cz>
 <20110224164913.GT2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56354 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab1BXSb2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 13:31:28 -0500
Content-Disposition: inline
In-Reply-To: <20110224164913.GT2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 24-02-11 11:49:13, Ted Ts'o wrote:
> On Thu, Feb 24, 2011 at 02:57:40PM +0100, Jan Kara wrote:
> >   I've actually tried that before posting my email and it's not like that.
> > I did:
> > jack@quack:~/source> echo 'aaa' >/tmp/f
> > jack@quack:~/source> chmod 600 /tmp/f
> > jack@quack:~/source> setfacl -m u:nobody:rw /tmp/f
> > jack@quack:~/source> sudo su nobody -c "cat /tmp/f"
> > aaa
> > jack@quack:~/source> sudo su news -c "cat /tmp/f"
> > cat: /tmp/f: Permission denied
> 
> Hmm... yes, but it's a bit more complicated.  Look at this, and note
> how remounting the file system without acl's gave the group "users" rw
> access to the file /mnt/f.
  Ah OK, I see. So it's both ways ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
