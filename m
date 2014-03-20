From: tytso@mit.edu
Subject: Re: [PATCH] ext4: kill i_version support for Hurd-castrated file
 systems
Date: Thu, 20 Mar 2014 10:44:56 -0400
Message-ID: <20140320144456.GA20618@thunk.org>
References: <20140319202009.GA21361@jessie01>
 <1395290051-25682-1-git-send-email-tytso@mit.edu>
 <3DF297F8-04E0-4EE6-8CD5-127997293D5A@dilger.ca>
 <20140320081048.GA21164@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"1o5g4r8o@gmail.com" <1o5g4r8o@gmail.com>,
	"738758@bugs.debian.org" <738758@bugs.debian.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44049 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964883AbaCTOpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2014 10:45:12 -0400
Content-Disposition: inline
In-Reply-To: <20140320081048.GA21164@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2014 at 01:10:48AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 19, 2014 at 11:27:57PM -0600, Andreas Dilger wrote:
> > Probably worthwhile to make those !EXT4_OS_HURD checks likely()?

Yes, and I was planning on optimizing the checks a bit more, but it
makes sense to do that in a separate patch, since this is not the only
place where we are making EXT4_OS_HURD checks.

> 
> Does it make sense to support the format at all given that it's unlikely
> to get any testing?

There are some crazy people still trying to make the Hurd a viable
file system.  There's even a Debian port for it.  :-) The problem is
that some of the folks who are still trying to make the Hurd real want
to use ext2 as an interchange format between Linux and Hurd, and
presumably that's how they ran across this particular bug.

While I think Hurd is a joke, and it's laughable that the primary file
system for the Hurd doesn't support journalling, or extents, delayed
allocation, or extended attributes[1], and it's hard for them get feature
parity because of the GPL v3 vs v2 compatibility problem, I don't mind
making minimal efforts to provide legacy support to the GNU Hurd.

[1] http://savannah.gnu.org/patch/?5126 (Patches available for the last
      seven years, not yet integrated)

In the long run, the right answer is that the Hurd should use an
extended attribute to store the translator information.  Indeed, this
has been discussed seven years ago[2].  But unfortunately, the
development temp for Hurd is a wee bit slower than for the Linux
kernel.  :-)

[2] http://savannah.gnu.org/task/?5503

					- Ted
