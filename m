From: tytso@mit.edu
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart
Date: Tue, 25 May 2010 17:44:47 -0400
Message-ID: <20100525214447.GA14530@thunk.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
 <20100525133241.GF5556@thunk.org>
 <87632ckqcy.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com, tytso@mit.ed
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52723 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519Ab0EYVot (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 17:44:49 -0400
Content-Disposition: inline
In-Reply-To: <87632ckqcy.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 06:28:29PM +0400, Dmitry Monakhov wrote:
> tytso@mit.edu writes:
> 
> > On Thu, Apr 22, 2010 at 08:31:11AM +0400, Dmitry Monakhov wrote:
> >> @@ -2480,6 +2480,11 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start)
> >>  out:
> >>  	ext4_ext_drop_refs(path);
> >>  	kfree(path);
> >> +	if (err == EAGAIN) {
> >
> > Surely this should be "err == -EAGAIN", no?  I'm curious how this
> > patch worked for with this typo....
> As usually it fix one thing, and broke another :(.
> So in case of alloc/truncate restart truncate will be aborted,
> so i_size != i_disk_size which must be caught by fsck (my test run
> it every time) but this never happens which is very strange.

What test case are you using?  And does it require a system crash to
show up, or are you seeing an fsck problem after the test completes
and you unmount the file system?

						- Ted
