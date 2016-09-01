From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Thu, 1 Sep 2016 09:40:17 -0700
Message-ID: <20160901164016.GB25818@birch.djwong.org>
References: <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
 <20160805191548.GD19960@birch.djwong.org>
 <20160808035634.GA16193@thunk.org>
 <20160808062810.GC8590@birch.djwong.org>
 <8b8fff2d-5c89-856a-65d2-f6962b875f8f@etorok.net>
 <20160817232833.GF14651@birch.djwong.org>
 <dee1ff49-fea3-6f48-3d53-3737bdda135b@etorok.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
        Daeho Jeong <daeho.jeong@samsung.com>,
        Youngjin Gil <youngjin.gil@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Johannes Stezenbach <js@sig21.net>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dee1ff49-fea3-6f48-3d53-3737bdda135b@etorok.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 22, 2016 at 10:33:08AM +0300, Török Edwin wrote:
> On 2016-08-18 02:28, Darrick J. Wong wrote:
> > On Wed, Aug 17, 2016 at 05:27:25PM +0300, Török Edwin wrote:
> >> On 2016-08-08 09:28, Darrick J. Wong wrote:
> >>> On Sun, Aug 07, 2016 at 11:56:34PM -0400, Theodore Ts'o wrote:
> >>>> On Fri, Aug 05, 2016 at 12:15:48PM -0700, Darrick J. Wong wrote:
> >>>>>>> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/ext4/inode.c?id=b47820edd1634dc1208f9212b7ecfb4230610a23
> >>>>>>
> >>>>>> I added the patch, rebuilt and rebooted.  It will take some time
> >>>>>> before I'll report back since the issue is so hard to reproduce.
> >>>>>
> >>>>> FWIW I could trigger it reliably by running a bunch of directory traversal
> >>>>> programs simultaneously on the same directory.  I have a script that fires
> >>>>> up multiple mutts pointing to the Maildirs for the high traffic Linux lists.
> >>>>
> >>>> Hmm, I wonder if we should request that this patch be backported to
> >>>> -stable.  Darrick, what do you think?
> >>>
> >>> Seems like an excellent idea.
> >>
> >> Hi,
> >>
> >> I see 4.7.1. was released, however before testing it in the changelog I can't
> >> see the inode.c commit with the checksum fix.  Is there another commit that
> >> would provide an equivalent fix, or is the fix not part of 4.7.1?
> > 
> > There's no 'equivalent' fix; the one we have simply didn't make it
> > to the stable maintainers before 4.7.1 came out.
> > 
> > (Hey Ted, can you send the patch to ... whomever's in charge of 4.7?)
> 
> Ping? 4.7.2 is out....
> 
> The process for submitting to stable seems to be described here [1], it
> doesn't say who can submit, but I  guess it'd be better if one of the people
> listed in the original commit, or an ext4 maintainer submitted it.
> 
> FWIW 4.7.0+patch has been working reliably here, would be nice if I could
> tell people here that its safe to upgrade to 4.7.x (without manually patching
> it).

Ted, ping for stable inclusion please? :)

--D

> 
> Best regards,
> --Edwin
