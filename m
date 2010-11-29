From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 17:20:25 +0100
Message-ID: <201011291720.26440.bernd.schubert@fastmail.fm>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx> <201011291618.25084.bernd.schubert@fastmail.fm> <4CF3CCD3.8040608@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Jonathan Nieder <jrnieder@gmail.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38829 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013Ab0K2QU2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 11:20:28 -0500
In-Reply-To: <4CF3CCD3.8040608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, November 29, 2010, Eric Sandeen wrote:
> On 11/29/10 9:18 AM, Bernd Schubert wrote:
> > On Monday, November 29, 2010, Ted Ts'o wrote:
> >> By using sync_file_range() first, for all files, this forces the
> >> delayed allocation to be resolved, so all of the block bitmaps, inode
> >> data structures, etc., are updated.  Then on the first fdatasync(),
> >> the resulting journal commit updates all of the block bitmaps and all
> >> of the inode table blocks(), and we're done.  The subsequent
> >> fdatasync() calls become no-ops --- which the ftrace shell script will
> >> show.
> > 
> > Wouldn't it make sense to modify ext4 or even the vfs to do that on
> > close() itself? Most applications expect the file to be on disk after a
> > close anyway
> 
> but those applications would be wrong.

Of course they are, I don't deny that. But denying the most applications 
expect the file to be on disk after a close() also denies reality, in my 
experience.
And IMHO, such temporary files as pointed out by Ted either should go to tmpfs 
or should be specially flagged as something like O_TMP. Unfortunately, that 
changes symantics and so indeed the only way left is to do it the other way 
around as Ted suggested.


Cheers,
Bernd
