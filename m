From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Ext4 slow on links
Date: Fri, 22 Jun 2012 10:08:18 -0400
Message-ID: <20120622140818.GA28155@thunk.org>
References: <4FE14034.6070800@redhat.com>
 <20120620002014.GA25471@gamma.logic.tuwien.ac.at>
 <20120620021912.GA26323@thunk.org>
 <20120620033831.GA2395@gamma.logic.tuwien.ac.at>
 <BA050E9A-2385-4FF9-B41A-3A25F3FF066A@redhat.com>
 <20120620051844.GA7829@gamma.logic.tuwien.ac.at>
 <4FE1D91B.8020707@redhat.com>
 <20120621022818.GD9669@gamma.logic.tuwien.ac.at>
 <4FE29DA7.40405@redhat.com>
 <4FE44089.2010609@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Norbert Preining <preining@logic.at>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51964 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915Ab2FVOIZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2012 10:08:25 -0400
Content-Disposition: inline
In-Reply-To: <4FE44089.2010609@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 22, 2012 at 11:53:13AM +0200, Bernd Schubert wrote:
> On 06/21/2012 06:05 AM, Eric Sandeen wrote:
> >On 6/20/12 9:28 PM, Norbert Preining wrote:
> >>Hi Eric,
> >>
> >
> >You could see if you could get this LD_PRELOAD working:
> >
> >http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob_plain;f=contrib/spd_readdir.c
> >
> 
> Hrmm, I need to look through that commit again, but on a first
> glance I cannot see code doing the sorting for ext3/ext4 only (e.g.
> by checking the fsid). So while I like the general approach, it will
> have the opposite effect for some file systems. I will report that
> back on the coreutils list.
> 
> Thanks a lot for the pointer to the commit!

One warning about spd_readdir.  It's not thread-safe, and I've noted
that some programs crash when they try using spd_readdir.so as a
pre-load.  I've tried to fix some of the causes, and I think
thread-safety is the primary fix which is missing, but it's possible
that program which really care about telldir()/seekdir() behaviour as
it relates to readdir() and when files are added to a directory may
also end up getting surprised.

I wrote it primarily as a demonstration of how sorting by inode number
is a big win.  It is *not* suitable for use in /etc/ld.so.preload!

If people want to try to make it safer, patches are accepted, but
ultimately it's better to fix this in the application; that way you
will get your performance gains no matter what OS you happen to be
running on, whether it's Linux, Solaris, AIX, OS X, etc.

     	       	     	   	    	- Ted
