From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 13:02:47 -0400
Message-ID: <20120314170247.GC28042@thunk.org>
References: <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org>
 <4F5FAC9C.9070607@gmail.com>
 <20120313213304.GB11969@thunk.org>
 <alpine.LFD.2.00.1203140825090.5379@dhcp-27-109.brq.redhat.com>
 <20120314125002.GH15379@thunk.org>
 <alpine.LFD.2.00.1203141507220.14894@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <phillsusi@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36845 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291Ab2CNRCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Mar 2012 13:02:51 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203141507220.14894@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 14, 2012 at 03:34:13PM +0100, Lukas Czerner wrote:
> > 
> > You can make it be a RO_COMPAT change instead of an INCOMPAT change,
> > yes.
> 
> Does it have to be RO_COMPAT change though ? Since this would be both
> forward and backward compatible.

The challenge is how do you notice if the file system is mounted on an
older kernel, which then inserts a directory entry without updating
the secondary tree.  The older kernel won't know about the new inode
flag, so it can't clear the flag when it modifies the directory.

We were able to get away with making the original htree feature
read/write compatible because the design for it was anticipated far in
advance, and because it was before the days of enterprise kernels that
had to be supported for seven years.  So we added code into ext3 to
clear the the htree flag whenever the directory was modified something
like two years before the htree code made its appearance, and back
then we decided that was fair to assume no one would be using a kernel
that old, or be jumping back and forth between an ancient kernel and a
modern kernel with htree enabled.  Yes, that was playing a bit fast
and loose, but early on in the kernel history, we could do that.  It's
not something I would do today.

The bigger deal is that as Zach pointed out, we can't just index it by
inode number because we have to worry about hard links.  Which means
we need either an explicit counter field added to the directory entry,
or some kind of new offset field.  That we can't just shoehorn in and
retain backwards compatibility.

And once we break backwards compatibility, we might as well look at
the full design space and see what is the most optimal.

    	 	      	      	      	  - Ted
