From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Tue, 26 Mar 2013 13:55:30 +0800
Message-ID: <20130326055530.GB17165@gmail.com>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <5149C452.3070206@redhat.com>
 <20130320144523.GF12865@thunk.org>
 <20130326055251.GA17165@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36938 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3CZFqY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2013 01:46:24 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so257237pad.16
        for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2013 22:46:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130326055251.GA17165@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 01:52:51PM +0800, Zheng Liu wrote:
> Sorry for the late reply.
> 
> On Wed, Mar 20, 2013 at 10:45:23AM -0400, Theodore Ts'o wrote:
> > On Wed, Mar 20, 2013 at 09:14:42AM -0500, Eric Sandeen wrote:
> > > 
> > > As an aside, is there any reason to have "dioread_nolock" as an option
> > > at this point?  If it works now, would you ever *not* want it?
> > > 
> > > (granted it doesn't work with some journaling options etc, but that
> > > behavior could be automatic, w/o the need for special mount options).
> > 
> > The primary restriction is that diread_nolock doesn't work when fs
> > block size != page size.  If your proposal is that we automatically
> > enable diread_nolock when we can use it safely, that's definitely
> > something to consider for the next merge window.
> 
> Yes, I also think we can automatically enable dioread_nolock because it
> brings us some benefits.
> 
> BTW, I think there is an minor improvement for dio overwrite codepath
> with indirect-based file.  We don't need to take i_mutex in this
> condition just as we have done for extent-based file.  If a user mounts
> a ext2/3 file system with a ext4 kernel modules, he/she could get a
> lower latency.  But it seems that it would break dio semantic in ext2/3.
> Currently in ext2/3 if we issue a overwrite dio and then issue a read
> dio.  We will always read the latest data because we wait on i_mutex
> lock.  But after parallelizing overwite dio, this semantic might breaks.
> I re-read this doc but it seems that it doesn't describe this case.
                 ^^^

Ah, sorry, I forgot to paste the link here.
https://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO%27s_Semantics

Regards,
                                                - Zheng
