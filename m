From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: "make check" broken on maint branch?
Date: Thu, 31 Oct 2013 23:21:15 -0400
Message-ID: <20131101032115.GA14263@thunk.org>
References: <CE98293A.7BB07%andreas.dilger@intel.com>
 <20131101023556.GA28605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Dilger, Andreas" <andreas.dilger@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53133 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab3KADVU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Oct 2013 23:21:20 -0400
Content-Disposition: inline
In-Reply-To: <20131101023556.GA28605@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 01, 2013 at 10:35:56AM +0800, Zheng Liu wrote:
> Hi Andreas,
> 
> On Thu, Oct 31, 2013 at 09:35:25PM +0000, Dilger, Andreas wrote:
> > I tried to add in a "truncate -s $SIZE_2 $TMPFILE", but it complains that
> > it
> > isn't able to truncate the file in /tmp to 2TB:
> > 
> >   truncating `/tmp/e2fsprogs-tmp.OGxb09' at 2199023255552 bytes: File too
> > large
> > 
> > Testing manually, it seems I'm not allowed to create a file in tmpfs larger
> > than 256GB.  How large does this file need to be for this test to be valid?
> > 
> > Anyone else seen these problems, or do I need to dig in further?
> 
> Yes, I also can see these problems.

Hmm.... it works for me.  Run while r_64bit_big_expand is running:

% ls -l tmp
...
24896 -rw-r--r--. 1 tytso      tytso      2199023255552 Oct 31 23:17 e2fsprogs-tmp.pkOcCc
...

% df /tmp
Filesystem     1K-blocks  Used Available Use% Mounted on
tmpfs            3216420 26008   3190412   1% /tmp

What version of the kernel are you running?  I am using 3.12-rc5 plus
the ext4 dev tree, so I'm using a pretty recent kernel.

Maybe this is a relatively new feature of tmpfs?  If so, I should
probably change the test so that it's a bit more portable on people
using older kernels.

    	     	     	      	  - Ted
