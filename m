From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an
 invalid file system
Date: Tue, 29 May 2012 08:18:38 -0400
Message-ID: <20120529121838.GA16351@thunk.org>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
 <20120529082144.GA18792@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120529082144.GA18792@kroah.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 29, 2012 at 05:21:44PM +0900, Greg KH wrote:
> On Mon, May 28, 2012 at 01:33:42PM -0400, Theodore Ts'o wrote:
> > If we rmdir a directory which is a hard link to '.', we will deadlock
> > trying to grab the directory's i_mutex.  Check for this condition and
> > return EINVAL, which is what we return if the user attempts to rmdir
> > "/foo/bar/."
> > 
> > Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/namei.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> 
> Any reason why you didn't also tag this for the stable kernel releases?

Because I was sending it out for comment; I wanted to get Al's opinion
how to handle whether we needed to inform the low-level file system
about the corruption.  I should have added an RFC to the subject line,
sorry.

Andrea's solution of detecting the corruption is lookup seems like the
right answer, so at this point, I'll remove the XXX comment, and add
the unlikely() annotation to the if statement, and resubmit with a Cc:
stable.

						- Ted
