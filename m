From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic file data replace API
Date: Mon, 27 Dec 2010 21:59:37 -0500
Message-ID: <20101228025937.GE10149@thunk.org>
References: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57269 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0L1C7z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Dec 2010 21:59:55 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 27, 2010 at 12:51:54PM +0100, Olaf van der Spek wrote:
> Since the introduction of ext4, some apps/users have had issues with
> file corruption after a system crash. It's not a bug in the FS AFAIK
> and it's not exclusive to ext4.
> Writing a temp file, fsync, rename is often proposed.
> But how does one preserve meta-data, including file owner?

What's the use case where preserving file ownership matters?

       	       	    	  	     	  - Ted
