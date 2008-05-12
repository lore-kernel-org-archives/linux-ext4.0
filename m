From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC PATCH 7/9][e2fsprogs] Add new blk64_t handling inline
 functions
Date: Mon, 12 May 2008 12:25:21 -0500
Message-ID: <20080512122521.4f9b270e@gara>
References: <20080509163928.15484.22146.stgit@gara>
	<20080509164012.15484.60952.stgit@gara>
	<20080512144903.GE7029@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54661 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbYELRY0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 13:24:26 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4CHONaj017861
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:24:23 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4CHONP7099648
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:24:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4CHONlL026972
	for <linux-ext4@vger.kernel.org>; Mon, 12 May 2008 13:24:23 -0400
In-Reply-To: <20080512144903.GE7029@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 May 2008 10:49:03 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Fri, May 09, 2008 at 11:40:12AM -0500, Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > Add new blk64_t handling inline functions
> > 
> > Introduce inline fuctions to handle blk64_t and low/high values in
> > super blocks and inodes.
> 
> If you do this patch first, then you can address some of the FIXME's
> earlier in the patch series...

Will do.
 
> And as I mentioned, we probably want to avoid making them INLINE
> functions.  It's always easier to inline a function later if we find
> that it shows up on profiles for performance reasons, but if we find
> out we need to make changes and it is inline already, it's much harder
> to deal with the backwards compatibility issues.

I agree that making the not inline is the right thing to do, but now
the question is where do we put these new functions.  Is it still
appropriate to place them in ext2fs.h or do you prefer a new location?

> 						- Ted

-JRS
