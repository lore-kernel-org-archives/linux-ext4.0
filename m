From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Thu, 03 Sep 2009 01:11:10 -0400
Message-ID: <15737.1251954670@gamaville.dokosmarshall.org>
References: <12386.1251948115@gamaville.dokosmarshall.org>
 <4A9F4B57.9080602@redhat.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vms173017pub.verizon.net ([206.46.173.17]:44127 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZICFLU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 01:11:20 -0400
Received: from gamaville.dokosmarshall.org ([98.110.172.159])
 by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KPD005VBQEKNAI4@vms173017.mailsrvcs.net> for
 linux-ext4@vger.kernel.org; Thu, 03 Sep 2009 00:11:09 -0500 (CDT)
In-reply-to: Message from Eric Sandeen <sandeen@redhat.com> of
 "Wed, 02 Sep 2009 23:51:35 CDT." <4A9F4B57.9080602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> wrote:

> > 
> > Replace all field accesses with calls to access functions.
> > Most importantly, get rid of the mis-declared group descriptor
> > pointer which caused the wrong fields to be updated.
> 
> Not quite sure what you mean by this?  It worked ok for the "old" size ...
> 

Yes, it worked fine for the old ext2_group_desc structure, but it has no
hope of working with the ext4_group_desc: the sizes are different, so
doing bg++ gets it pointing somewhere within the first descriptor, not
to the beginning of the second. That's how it ended up modifying
reserved fields.

Sorry about the whitespace problems.  As for the flags, I didn't worry
too much about how to set them: I figured that once the dust settles,
we'll follow the proper convention.

Thanks for looking it over and testing too! We'll see whether Justin's
problem disappears.

Nick
