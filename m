From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/32] ext4: extended attribute value size limit is
 enforced by vfs
Date: Thu, 22 Jun 2017 18:27:08 -0400
Message-ID: <20170622222708.w6uouwzfiihwmlvd@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-9-tahsin@google.com>
 <20170622180243.GC4728@birch.djwong.org>
 <B0650C7F-0982-4D10-ADC9-925B376D92BE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B0650C7F-0982-4D10-ADC9-925B376D92BE@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 22, 2017 at 01:40:25PM -0600, Andreas Dilger wrote:
> 
> The EXT4_XATTR_MAX_LARGE_EA_SIZE limit of 1MB was also totally arbitrary,
> but a reasonable upper limit for the atomic get/set interface used by
> xattrs.  The underlying disk format could actually store xattrs of any size.
> 
> I'd think if we want to get huge xattrs that they should be handled by
> having separate streams (e.g. open file descriptor, ioctl/syscall to select
> a different stream number on that file) so that the data doesn't have to be
> completely rewritten any time it is modified, but streams are frowned upon
> by many Linux developers for security reasons so will probably be a no-go.

This has been discussed before.  Most of the arguments (both pro and
con) can be found on this thread (2016):

	https://www.spinics.net/lists/linux-nfs/msg57055.html

Jeremy Allison used to pester me for alternate data stream support
many years ago, but he has since completely changed his opinion on the
matter:

	http://www.spinics.net/lists/linux-fsdevel/msg96083.html

So if jra@ doesn't add support for this interface to Samba, the thing
I'd ask is who is actually going to used such an interface; because if
there aren't any user space applications lining up to use it, it's
probably not worth adding it until we can find a flagship user of the
proposed new API.

There are plenty of other things we could add that Jeremy has asked
for, that *would* improve Samba performance.  (For example, adding a
mount option which provides case-insensitive lookup; the one thing
that makes this hard is that while Android doesn't seem to care about
I18N --- they are currently using an ascii-only tolower() in their
sdcardfs hack --- Samba/Windows does care about I18N done right, so we
wouldn't have to get a Unicode case folding implementation into the
kernel.)  So I'd argue that those are probably more interesting
projects than O_XATTR support.

	       	  	       	    - Ted
