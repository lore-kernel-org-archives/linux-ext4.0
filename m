From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: new block group bitmaps not being initialized after resize!?
Date: Sun, 13 Jan 2013 08:37:06 -0500
Message-ID: <20130113133706.GA30477@thunk.org>
References: <20130111000711.GA2490@andromeda.usersys.redhat.com>
 <50EF65C3.8010406@redhat.com>
 <25BFE2C2-8FF2-4064-86D3-6CFBF5A2931F@dilger.ca>
 <50F033F5.6080008@redhat.com>
 <20130113043615.GE19503@thunk.org>
 <AA104FC2-C0C6-4465-8AA1-74D99E19EE9C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43063 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab3AMNhM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jan 2013 08:37:12 -0500
Content-Disposition: inline
In-Reply-To: <AA104FC2-C0C6-4465-8AA1-74D99E19EE9C@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 13, 2013 at 12:26:45AM -0500, Eric Sandeen wrote:
> > The flag names are confusing.  INODE_ZEROED means that the inode table
> > is not zero'ed.
> 
> Please tell me you said that backwards?

Yes, sorry...

> If setting the unused inode count is enough, then I guess it's resolved...

Well, modulo a patch to make sure the lazy init thread gets kicked
off, so that eventually we do end up zeroing the inode table (just in
case something goes wrong and we can't trust the block group
descriptor checksum).  I just finished that off last night, and it's
now ready for review (see next message).

						- Ted


