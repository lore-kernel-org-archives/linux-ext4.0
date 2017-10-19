From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Ext4 support for LTS kernels (was: Re: [PATCH 3.14] ext4: fix
 data exposure after a crash)
Date: Thu, 19 Oct 2017 13:35:19 +0200
Message-ID: <20171019113519.GA15262@kroah.com>
References: <146507681324370@kroah.com>
 <1467153108-104061-1-git-send-email-george_davis@mentor.com>
 <20160629074600.GB14082@quack2.suse.cz>
 <dcfd784fe927475fb98356abbea36179@SGPMBX1004.APAC.bosch.com>
 <20171009110537.GH17917@quack2.suse.cz>
 <20171009132004.y6rale4k7oll3hab@thunk.org>
 <20171010181710.GL747@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
        "George G. Davis" <george_davis@mentor.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Behme Dirk (CM/ESO2)" <Dirk.Behme@de.bosch.com>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010181710.GL747@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 10, 2017 at 08:17:10PM +0200, Greg KH wrote:
> On Mon, Oct 09, 2017 at 09:20:04AM -0400, Theodore Ts'o wrote:
> > On Mon, Oct 09, 2017 at 01:05:37PM +0200, Jan Kara wrote:
> > > On Fri 06-10-17 10:04:41, HUANG Weller (CM/ESW12-CN) wrote:
> > > > I checked the latest 3.14 source code 3.14.79. I didn't found the below patch.
> > > 
> > > Well, I'm not sure who runs the 3.14 stable tree (it's not listed at
> > > kernel.org). It's up to him to pick up patches...
> > 
> > The announcement of 3.14's End of Life as a stable kernel series was
> > announced in September 2016.  As far as I know, the fact that 3.14 is
> > no longer listed on kernel.org means that no one is maintaining 3.14
> > after Greg K-H declared it to be EOL'ed.
> 
> Yes, 3.14 is dead :)
> 
> > On a side note, I just recently finished an effort to update the ext4
> > patches for 3.14, 4.1, 4.4, and 4.9.  I've sent those backports and
> > cherry pick requests to stable@vger.kernel.org.  For details of my
> > work, at:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> > 
> > There are testing notes in the signed git tags:
> > 
> > ext4-4.9.54-1
> >    - https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/tag/?h=ext4-4.9.54-1
> > ext4-4.4.91-1
> >    - https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/tag/?h=ext4-4.4.91-1
> > ext4-4.1.44-1
> >    - https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/tag/?h=ext4-4.1.44-1
> > ext4-3.18.74-1
> >    - https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/tag/?h=ext4-3.18.74-1
> > 
> > .... and on a "when Ted has time / interest basis", the ext4-3.18,
> > ext4-4.1, ext4-4.4, and ext-4.9 branches in the above repo will be
> > updated with a rebase against the latest LTS kernel and whatever
> > patches are needed to minimize xfstests failures that haven't yet
> > gotten accepted into the LTS kernel versions.
> 
> Thanks so much for this work.  I think I've gotten most of these for
> 4.9, 4.4, and 3.18, I've emailed about the ones that didn't apply.

I dug in your branches above, and found the one missing patch for 3.18.
So I think I am all caught up now.

If not, please let me know.

thanks,

greg k-h
