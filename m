From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 16:12:35 -0500
Message-ID: <20091108211235.GA7592@mit.edu>
References: <bug-14354-13602@http.bugzilla.kernel.org/> <200911082105.nA8L5eFA002306@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56217 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbZKHVMf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Nov 2009 16:12:35 -0500
Content-Disposition: inline
In-Reply-To: <200911082105.nA8L5eFA002306@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> First off, it's slower. Secondly, 'l' is already 'strlen+1', so it looks 
> like ext4 _already_ copies the NUL terminating character.
> 
> So I suspect the debugging patch complained about writing a NUL to a 
> location that was already NUL to begin with.

Umm, yeah.  Good point.  Since the debugging patch marks the page ro,
short of doing a test before trying to null-terminate the symlink, the
debugging patch is always going to flag a false-positive here.

	  	   	  	   	- Ted
