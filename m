From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: enable acls and user_xattr by default
Date: Thu, 24 Feb 2011 07:19:46 -0500
Message-ID: <4688CF7A-2859-465B-B0EC-B4E31800E5F2@mit.edu>
References: <4D5ED705.7010902@redhat.com> <20110221134642.GC6584@quack.suse.cz> <4D629C78.60600@redhat.com> <20110223173152.GM2924@thunk.org> <20110224114914.GD23042@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:48304 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab1BXMTw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 07:19:52 -0500
In-Reply-To: <20110224114914.GD23042@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 24, 2011, at 6:49 AM, Jan Kara wrote:

>  I agree it may cause surprises although it's not true that ACL's remove
> rights. Rather on contrary ACL's can only give additional rights (i.e. you
> have 600 file + user foo can also read it) thus noacl->acl transition might
> be insecure if you have some old unwanted ACL's pending.

My understanding of how POSIX acls work is that the if you want to give
read access to user "foo" (where "foo" is not the user) is you first have to 
open up the file permissions to do the equivalent of "o+r".

See: http://acl.bestbits.at/man/man5/acl.txt

And then note how ACL_MASK corresponds to the permissions bits...

-- Ted

