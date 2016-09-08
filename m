From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Fwd: [STABLE CHERRYPICK] ext4: avoid modifying checksum fields
 directly during checksum verification
Date: Thu, 8 Sep 2016 08:27:49 -0700
Message-ID: <20160908152749.GA9304@birch.djwong.org>
References: <20160906022955.qopdwuznvtqlwofq@thunk.org>
 <40811621-e317-fecc-8052-56b88fd5ce35@etorok.net>
 <20160908085615.GA21050@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
        stable@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160908085615.GA21050@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 08, 2016 at 10:56:15AM +0200, Greg KH wrote:
> On Thu, Sep 08, 2016 at 10:21:34AM +0300, Török Edwin wrote:
> > Hi,
> > 
> > Not sure if this was sent to the right place: stable@kernel.org
> > doesn't seem to exist, I can't find this message in the ML archives,
> > or the 4.7.3 changelog.  Could you please include this in 4.7.4, I've
> > been waiting for this patch to get included ever since 4.7.1...
> 
> Yeah, I never saw it.
> 
> Will add it to the queue, it's long, might take a release or two to make
> it...
> 
> Were there any objections from the ext4 maintainers in taking the patch
> below?

None here.  I'll see if I can poke Ted too.

--D

> 
> thanks,
> 
> greg k-h
> 
> > -------- Forwarded Message --------
> > Subject: [STABLE CHERRYPICK] ext4: avoid modifying checksum fields directly during checksum verification
> > Date: Mon, 5 Sep 2016 22:29:55 -0400
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: stable@kernel.org
> > CC: linux-ext4@vger.kernel.org, Török Edwin <edwin@etorok.net>
> > 
> > Hi, please cherry pick the following commit into the stable kernels.
> > The commit landed in 4.8-rc1.  It wasn't marked with a cc:
> > stable@kernel.org, but it should be backported since it affecting a
> > number of users who are trying to use ext4's metadata checksum
> > feature.
> > 
> > Thanks!!
> > 
> > commit b47820edd1634dc1208f9212b7ecfb4230610a23
> > Author: Daeho Jeong <daeho.jeong@samsung.com>
> > Date:   Sun Jul 3 17:51:39 2016 -0400
> > 
> >     ext4: avoid modifying checksum fields directly during checksum verification
> >     
> >     We temporally change checksum fields in buffers of some types of
> >     metadata into '0' for verifying the checksum values. By doing this
> >     without locking the buffer, some metadata's checksums, which are
> >     being committed or written back to the storage, could be damaged.
> >     In our test, several metadata blocks were found with damaged metadata
> >     checksum value during recovery process. When we only verify the
> >     checksum value, we have to avoid modifying checksum fields directly.
> >     
> >     Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> >     Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
> >     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> >     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > 						- Ted
> > 						
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
