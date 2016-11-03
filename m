From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC 0/6] vfs: Add timestamp range check support
Date: Wed, 2 Nov 2016 23:54:19 -0700
Message-ID: <20161103065419.GA5248@birch.djwong.org>
References: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com>
 <20161102224827.GJ14023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, tglx@linutronix.de, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, tytso@mit.edu, viro@zeniv.linux.org.uk,
        y2038@lists.linaro.org, linux-afs@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102224827.GJ14023@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 03, 2016 at 09:48:27AM +1100, Dave Chinner wrote:
> On Wed, Nov 02, 2016 at 08:04:50AM -0700, Deepa Dinamani wrote:
> > The series is aimed at adding timestamp checking and policy
> > related to it to vfs.
> > 
> > The series was developed with discussions and guidance from
> > Arnd Bergmann.
> > 
> > The original idea for the series was the discussion:
> > https://lkml.org/lkml/2014/5/30/551
> > 
> > Patches 5 and 6 can be merged only after vfs is transitioned
> > to use 64 bit timestamps as noted in the respective commit
> > texts.
> > 
> > The series only includes adding range limits to filesystems:
> > ext4 and afs as examples to keep the series simple.
> > Every filesystem will be updated to add these limits.
> 
> We're going to need regression tests for this to ensure that it
> works properly and that we don't inadvertantly break it in future.
> Can you write some xfstests that exercise this functionality and
> validate that the mount behaviour, clamping and range limiting is
> working as intended?

Seconded. :)

I guess the only way to tell if a mountpoint can do 64 bit times is to
try it and see what happens?  Unless you enable the procfs thing that
prints to dmesg.  Evidently turning on the knob won't cause complaints
if there's already a mounted fs that didn't have 64-bit time support.
I'd go look at the testcases to corroborate this, but I don't know
that there are any?

(It was a big help to write a big pile of tests for adding reflink to
XFS.  It helped us find some btrfs reflink bugs too.)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
