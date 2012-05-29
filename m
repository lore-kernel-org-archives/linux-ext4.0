From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] vfs: avoid hang caused by attempting to rmdir an invalid
 file system
Date: Tue, 29 May 2012 17:21:44 +0900
Message-ID: <20120529082144.GA18792@kroah.com>
References: <1338226422-8845-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk, sami.liedes@iki.fi
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1338226422-8845-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 28, 2012 at 01:33:42PM -0400, Theodore Ts'o wrote:
> If we rmdir a directory which is a hard link to '.', we will deadlock
> trying to grab the directory's i_mutex.  Check for this condition and
> return EINVAL, which is what we return if the user attempts to rmdir
> "/foo/bar/."
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/namei.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Any reason why you didn't also tag this for the stable kernel releases?

thanks,

greg k-h
