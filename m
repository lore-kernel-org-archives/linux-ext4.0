From: "Myklebust, Trond" <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 16:43:05 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91F3D625D@sacexcmbx05-prd.hq.netapp.com>
References: <20130212202841.GC10267@fieldses.org>
	 <20130213040003.GB2614@thunk.org> <20130213133131.GE14195@fieldses.org>
	 <20130213151455.GB17431@thunk.org> <20130213151953.GJ14195@fieldses.org>
	 <20130213153654.GC17431@thunk.org> <20130213162059.GL14195@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	"gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org" <gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>,
	"linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130213162059.GL14195-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
Content-ID: <BB4769648796C749857DCF0BA5C274F4-oP88Kt8RkgzdA/Lu/QRl1Q@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2013-02-13 at 11:20 -0500, J. Bruce Fields wrote:
> Oops, probably should have cc'd linux-nfs.
> 
> On Wed, Feb 13, 2013 at 10:36:54AM -0500, Theodore Ts'o wrote:
> > On Wed, Feb 13, 2013 at 10:19:53AM -0500, J. Bruce Fields wrote:
> > > > > (In more detail: they're spreading a single directory across multiple
> > > > > nodes, and encoding a node ID into the cookie they return, so they can
> > > > > tell which node the cookie came from when they get it back.)
> > > > > 
> > > > > That works if you assume the cookie is an "offset" bounded above by some
> > > > > measure of the directory size, hence unlikely to ever use the high
> > > > > bits....
> > > > 
> > > > Right, but why wouldn't a nfs export option solave the problem for
> > > > gluster?
> > > 
> > > No, gluster is running on ext4 directly.
> > 
> > OK, so let me see if I can get this straight.  Each local gluster node
> > is running a userspace NFS server, right?
> 
> My understanding is that only one frontend server is running the server.
> So in your picture below, "NFS v3" should be some internal gluster
> protocol:
> 
> 
>                                                    /------ GFS Storage
>                                                   /        Server #1
>    GFS Cluster     NFS V3      GFS Cluster      -- gluster protocol
>    Client        <--------->   Frontend Server  ---------- GFS Storage
>                                                 --         Server #2
>                                                   \
>                                                    \------ GFS Storage
>                                                            Server #3
>  
> 
> That frontend server gets a readdir request for a directory which is
> stored across several of the storage servers.  It has to return a
> cookie.  It will get that cookie back from the client at some unknown
> later time (possibly after the server has rebooted).  So their solution
> is to return a cookie from one of the storage servers, plus some kind of
> node id in the top bits so they can remember which server it came from.
> 
> (I don't know much about gluster, but I think that's the basic idea.)
> 
> I've assumed that users of directory cookies should treat them as
> opaque, so I don't think what gluster is doing is correct.  But on the
> other hand they are defined as integers and described as offsets here
> and there.  And I can't actually think of anything else that would work,
> short of gluster generating and storing its own cookies.
> 
> > Because if it were running
> > a kernel-side NFS server, it would be sufficient to use an nfs export
> > option.
> > 
> > A client which mounts a "gluster file system" is also doing this via
> > NFSv3, right?  Or are they using their own protocol?  If they are
> > using their own protocol, why can't they encode the node ID somewhere
> > else?
> > 
> > So this a correct picture of what is going on:
> > 
> >                                                   /------ GFS Storage
> >                                                  /        Server #1
> >   GFS Cluster     NFS V3      GFS Cluster      -- NFS v3
> >   Client        <--------->   Frontend Server  ---------- GFS Storage
> >                                                --         Server #2
> >                                                  \
> >                                                   \------ GFS Storage
> >                                                           Server #3
> > 
> > 
> > And the reason why it needs to use the high bits is because when it
> > needs to coalesce the results from each GFS Storage Server to the GFS
> > Cluster client?
> > 
> > The other thing that I'd note is that the readdir cookie has been
> > 64-bit since NFSv3, which was released in June ***1995***.  And the
> > explicit, stated purpose of making it be a 64-bit value (as stated in
> > RFC 1813) was to reduce interoperability problems.  If that were the
> > case, are you telling me that Sun (who has traditionally been pretty
> > good worrying about interoperability concerns, and in fact employed
> > the editors of RFC 1813) didn't get this right?  This seems
> > quite.... surprising to me.
> > 
> > I thought this was the whole point of the various NFS interoperability
> > testing done at Connectathon, for which Sun was a major sponsor?!?  No
> > one noticed?!?
> 
> Beats me.  But it's not necessarily easy to replace clients running
> legacy applications, so we're stuck working with the clients we have....
> 
> The linux client does remap the server-provided cookies to small
> integers, I believe exactly because older applications had trouble with
> servers returning "large" cookies.  So presumably ext4-exporting-Linux
> servers aren't the first to do this.
> 
> I don't know which client versions are affected--Connectathon's next
> week and I'll talk to people and make sure there's an ext4 export with
> this turned on to test against.

Actually, one of the main reasons for the Linux client not exporting raw
readdir cookies is because the glibc-2 folks in their infinite wisdom
declared that telldir()/seekdir() use an off_t. They then went yet one
further and decided to declare negative offsets to be illegal so that
they could use the negative values internally in their syscall wrappers.

The POSIX definition has none of the above rubbish
(http://pubs.opengroup.org/onlinepubs/009695399/functions/telldir.html)
and so glibc brilliantly saddled Linux with a crippled readdir
implementation that is _not_ POSIX compatible.

No, I'm not at all bitter...

Trond
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
