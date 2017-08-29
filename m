From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Documentation: fix little inconsistencies
Date: Tue, 29 Aug 2017 09:50:57 -0700
Message-ID: <20170829165057.GB4750@magnolia>
References: <20170828094638.GA15378@amd>
 <20170828161707.GA4750@magnolia>
 <20170829072708.GA30643@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        tytso@mit.edu, corbet@lwn.net, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@osdl.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170829072708.GA30643@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 29, 2017 at 09:27:08AM +0200, Pavel Machek wrote:
> 
> 
> > > index 5e40e1f..6309e90 100644
> > > --- a/Documentation/networking/switchdev.txt
> > > +++ b/Documentation/networking/switchdev.txt
> > > @@ -29,7 +29,7 @@ with SR-IOV or soft switches, such as OVS, are possible.
> > >                        sw1p1  +  sw1p3  +  sw1p5  +          eth1
> > >                          +    |    +    |    +    |            +
> > >                          |    |    |    |    |    |            |
> > > -                     +--+----+----+----+-+--+----+---+  +-----+-----+
> > > +                     +--+----+----+----+----+----+---+  +-----+-----+
> > 
> > Except for this last part, looks ok.
> 
> Anything wrong here? It is fixing extra '+' in the ascii art...

There's nothing incorrect here, I merely thought it odd to send a fix
for networking documentation to the ext4 list, but not netdev?

--D

> 									Pavel
> 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> > >                       |         Switch driver         |  |    mgmt   |
> > >                       |        (this document)        |  |   driver  |
> > >                       |                               |  |           |
> > > 
> > > -- 
> > > (english) http://www.livejournal.com/~pavelmachek
> > > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> > 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
