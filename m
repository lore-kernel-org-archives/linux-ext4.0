From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: A couple of ext4 crashes with inlinedata/bigalloc
Date: Tue, 8 Apr 2014 11:40:03 -0700
Message-ID: <20140408184003.GB8888@birch.djwong.org>
References: <20140311030604.GK9875@birch.djwong.org>
 <20140408115425.GA23781@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbaDHSkL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 14:40:11 -0400
Content-Disposition: inline
In-Reply-To: <20140408115425.GA23781@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 08, 2014 at 07:54:25PM +0800, Zheng Liu wrote:
> On Mon, Mar 10, 2014 at 08:06:04PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > A couple of errors to complain about before I send out the e2fsprogs patchbomb.
> > :)
> > 
> > Zheng: I've been running the metadata checksum test with inline_data set.
> > flat_dir_test is a stress test which copies /usr/share/doc into a filesystem
> > and then "enlarges" the directories by recursively renaming "$foo" to
> > "$foo.longer", with the results below.  e2fsck complained that the directories
> > involved (4156, 4251) have multiple links to the subdir inode.  I'm not sure
> > what this is all about; the only (circumstantial) evidence I have is that it
> > goes away if I don't turn on inline_data.
> 
> Hi Darrick,
> 
> I guess that you were talking about this bug at LSF/MM submmit this
> year, right?  Thanks for reporting this bug.  I am trying to take a
> closer look at it.  It would be great if you could tell me where I can
> find the your test program ('flat_dir_test').

It's buried in the metadata checksum test suite, alas.  The test copies an
arbitrary directory (/usr/share/doc) to the filesystem, then does a depth-first
traversal of the copied tree, renaming everything it finds from "oldname" to
"oldname.longer" to force the kernel to shuffle directory entries all over the
place, and likely causing spill-out from formerly inlinedata directories.

--D
> 
> Regards,
>                                                 - Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
