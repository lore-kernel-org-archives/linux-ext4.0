From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] jbd2: remove debug dependency on debug_fs; update
 help text
Date: Thu, 13 Jun 2013 10:14:31 -0400
Message-ID: <20130613141431.GE13429@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-7-git-send-email-paul.gortmaker@windriver.com>
 <20130613030831.GG16959@thunk.org>
 <51B9CE63.9000509@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51B9CE63.9000509@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 13, 2013 at 09:51:31AM -0400, Paul Gortmaker wrote:
> On 13-06-12 11:08 PM, Theodore Ts'o wrote:
> > On Tue, Jun 11, 2013 at 06:44:30PM -0400, Paul Gortmaker wrote:
> >> commit b6e96d0067d8 ("jbd2: use module parameters instead of debugfs
> >> for jbd_debug") removed any need for a dependency on DEBUG_FS.  It
> >> also moved the /sys variables out from underneath the typical debugfs
> >> mount point.  Delete the dependency and update the /sys path to where
> >> the debug settings are currently.
> >>
> >> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > 
> > Applied, thanks.
> 
> Just a heads up -- it seems some script threw away the 1st line of the
> commit log here.

Thanks for noticing this.  Guilt is apparently stripping lines that
begin with "commit".  Using "Commit" avoids this.

      	   	      	    	     	    - Ted
