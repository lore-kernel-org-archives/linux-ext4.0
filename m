From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 16:18:24 +0100
Message-ID: <201011291618.25084.bernd.schubert@fastmail.fm>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx> <20101129072930.GA7213@burratino> <20101129144436.GT2767@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36262 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab0K2PS1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 10:18:27 -0500
In-Reply-To: <20101129144436.GT2767@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, November 29, 2010, Ted Ts'o wrote:
> By using sync_file_range() first, for all files, this forces the
> delayed allocation to be resolved, so all of the block bitmaps, inode
> data structures, etc., are updated.  Then on the first fdatasync(),
> the resulting journal commit updates all of the block bitmaps and all
> of the inode table blocks(), and we're done.  The subsequent
> fdatasync() calls become no-ops --- which the ftrace shell script will
> show.

Wouldn't it make sense to modify ext4 or even the vfs to do that on close() 
itself? Most applications expect the file to be on disk after a close anyway 
and I also don't see a good reason why one should delay a disk write-back 
after close any longer (well, there are exeption if the application is broken, 
for example such as ha-logd used by pacemaker, which did for each line of logs 
an open, seek, write, flush, close sequence..., but at least we have fixed 
that in -hg now).


Cheers,
Bernd
