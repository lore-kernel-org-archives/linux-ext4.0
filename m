From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 10:37:02 -0500
Message-ID: <20101129153702.GB7994@thunk.org>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx>
 <20101129072930.GA7213@burratino>
 <20101129144436.GT2767@thunk.org>
 <201011291618.25084.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60928 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0K2PhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 10:37:08 -0500
Content-Disposition: inline
In-Reply-To: <201011291618.25084.bernd.schubert@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 04:18:24PM +0100, Bernd Schubert wrote:
> 
> Wouldn't it make sense to modify ext4 or even the vfs to do that on
> close() itself? Most applications expect the file to be on disk
> after a close anyway and I also don't see a good reason why one
> should delay a disk write-back after close any longer (well, there
> are exeption if the application is broken, for example such as
> ha-logd used by pacemaker, which did for each line of logs an open,
> seek, write, flush, close sequence..., but at least we have fixed
> that in -hg now).

I can think of plenty of cases where it wouldn't make sense to do that
on a close().  For example, it would dramatically slow down compiles.
Just to give one example, you really don't want to force writeback to
start when the compiler finishes writing an intermediate .o file.  And
there are often temporary files which are created and then deleted
very shortly afterwards; forcing writeback just because the file has
been closed would be pointless.

Now, a hint that could be set via an open flag, or via fcntl(), saying
that *this* file is one that should really be written at close() time
--- that would probably be a good idea, if application/library authors
would actually use it.

      	       			 	    - Ted
