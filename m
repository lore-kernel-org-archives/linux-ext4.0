From: tytso@mit.edu
Subject: Re: Unify log messages in ext4
Date: Mon, 23 Nov 2009 09:11:08 -0500
Message-ID: <20091123141108.GC2532@thunk.org>
References: <4B087DEC.5010402@redhat.com>
 <1258918735-4496-1-git-send-email-bug-track@fisher-privat.net>
 <20091123103658.GA15679@duck.suse.cz>
 <1258976736.4103.1.camel@zwerg>
 <20091123115513.GD15679@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58021 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbZKWOLK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 09:11:10 -0500
Content-Disposition: inline
In-Reply-To: <20091123115513.GD15679@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 12:55:14PM +0100, Jan Kara wrote:
> On Mon 23-11-09 12:45:36, Alexey Fisher wrote:
> > Am Montag, den 23.11.2009, 11:36 +0100 schrieb Jan Kara:
> > > Thanks for the patch. I've merged it into my tree just with the following
> > > typo fixes.
> > 
> > Thank you,
> > are there any ext4 patches around? Or this will be my next step. 
>   I'm not aware of them...

Ext4 is using ext4_msg() already.  Eric Sandeen added it a while ago,
and the idea to convert ext2 and ext4 to use ext2_msg() and ext3_msg()
came from ext4.

					- Ted
