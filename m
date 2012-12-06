From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Ext4: Mount partition as read only if during orphan
 cleanup truncate fails to obtain journal handle.
Date: Thu, 6 Dec 2012 12:09:38 -0500
Message-ID: <20121206170938.GC30273@thunk.org>
References: <1351075240-2725-1-git-send-email-ashish.sangwan2@gmail.com>
 <CAKYAXd_6pHdPtOgOS4=_c6naWwPdMhna29OOKD919HrYM-+kaA@mail.gmail.com>
 <CAOiN93nKkFAc_t6J+c1w4F3V-MYaq9cv2wfAq3hyniWz5wYFMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOiN93nKkFAc_t6J+c1w4F3V-MYaq9cv2wfAq3hyniWz5wYFMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 06, 2012 at 04:59:43PM +0530, Ashish Sangwan wrote:
> 
> Did you get any time to look into this patch?
> This problem is with ext4 only as ext4_truncate does not clean the
> orphan list unlike that of ext3_truncate.
> Instead, in case of failure to obtain handle, orphan list cleanup is
> done in ext4_setattr.
> But during mount, ext4_truncate is not called via ext4_setattr and
> hence the problem.
> What do you think?

In the patch description, you mentioned that this occurs when the
there is a failure to obtain a journal handle.  Is this a hypothetical
thing that you exposed via some kind of tester which checks to see
what happens if kmalloc() randomly fails some number of allocation
requests?  Or was it happening in real life?  And if it is happening
in real life, do we understand why it's happening, and is there
something we should be doing to mitigate against the root cause of the
failure?

The alternative to your patch is to do something similar to what ext3
does.  That is, if there are any inodes left on the orphan list, to
iterate through them all and then clean up the orphan list.  Perhaps
we should then also call ext4_error() since technically the file
system may very well be inconsistent (there may be allocated inodes
holding blocks which are no longer connected the directory hierarchy,
which e2fsck would be able to clean up).  But that could potentially
cause the system to panic or remount the file system read-only,
depending on what the errors= behavior is set to.  Which is why I go
back to the original question; do we understand why ext4_truncate()
was failing during orphan cleanup in the first place?

    	    	   	  	     	       - Ted
