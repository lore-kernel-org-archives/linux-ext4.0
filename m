From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: New warning: Unable to get device geometry for [filename]
Date: Mon, 30 Jan 2012 14:34:33 +0000
Message-ID: <20120130143433.GW27709@amd.home.annexia.org>
References: <20120127225346.GA7449@amd.home.annexia.org>
 <4F237227.2000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab2A3Oeg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 09:34:36 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0UEYaCi027460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2012 09:34:36 -0500
Content-Disposition: inline
In-Reply-To: <4F237227.2000208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 27, 2012 at 09:57:27PM -0600, Eric Sandeen wrote:
> On 1/27/12 4:53 PM, Richard W.M. Jones wrote:
> > 
> > I've just noticed that with the latest e2fsprogs, kernel 3.3.0 and
> > blkid (util-linux 2.20.1), I see this spurious warning when using
> > mke2fs on a file:
> > 
> >   $ truncate -s 4G test1.img
> >   $ mke2fs -t ext2 -q -F test1.img 
> >   warning: Unable to get device geometry for test1.img
> > 
> > Oddly this *doesn't* happen except on the very bleeding edge latest
> > versions of everything.  I've not (yet) worked out exactly what
> > component has to be upgraded to see it ...
> 
> Taking a quick look, I don't _think_ anything above blkid changed
> in e2fsprogs lately, but keep us posted.

Some more observations:

- The warning is 32 bit *only*.  Sorry I didn't notice this rather
  obvious point before.  I have two identically configured Rawhide
  guests, except that one is i686 and the other is x86-64, and only
  the i686 guest gives this warning.

- If the disk is 1G, no warning.  After some binary searching I found
  the threshold for the warning is 'truncate -s 2048M' (greater than
  or equal gives the warning; smaller, no warning).

> Does mkfs.xfs do any differently?

No warning, at least, not with the default settings and a 4G disk on
32 bit.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
