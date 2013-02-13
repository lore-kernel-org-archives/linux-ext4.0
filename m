From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 11:20:59 -0500
Message-ID: <20130213162059.GL14195@fieldses.org>
References: <20130212202841.GC10267@fieldses.org>
	<20130213040003.GB2614@thunk.org>
	<20130213133131.GE14195@fieldses.org>
	<20130213151455.GB17431@thunk.org>
	<20130213151953.GJ14195@fieldses.org>
	<20130213153654.GC17431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130213153654.GC17431-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/gluster-devel>,
	<mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/gluster-devel>
List-Post: <mailto:gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Help: <mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/gluster-devel>,
	<mailto:gluster-devel-request-qX2TKyscuCcdnm+yROfE0A@public.gmane.org?subject=subscribe>
Errors-To: gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
Sender: gluster-devel-bounces+gcfgd-gluster-devel=m.gmane.org-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Oops, probably should have cc'd linux-nfs.

On Wed, Feb 13, 2013 at 10:36:54AM -0500, Theodore Ts'o wrote:
> On Wed, Feb 13, 2013 at 10:19:53AM -0500, J. Bruce Fields wrote:
> > > > (In more detail: they're spreading a single directory across multiple
> > > > nodes, and encoding a node ID into the cookie they return, so they can
> > > > tell which node the cookie came from when they get it back.)
> > > > 
> > > > That works if you assume the cookie is an "offset" bounded above by some
> > > > measure of the directory size, hence unlikely to ever use the high
> > > > bits....
> > > 
> > > Right, but why wouldn't a nfs export option solave the problem for
> > > gluster?
> > 
> > No, gluster is running on ext4 directly.
> 
> OK, so let me see if I can get this straight.  Each local gluster node
> is running a userspace NFS server, right?

My understanding is that only one frontend server is running the server.
So in your picture below, "NFS v3" should be some internal gluster
protocol:


                                                   /------ GFS Storage
                                                  /        Server #1
   GFS Cluster     NFS V3      GFS Cluster      -- gluster protocol
   Client        <--------->   Frontend Server  ---------- GFS Storage
                                                --         Server #2
                                                  \
                                                   \------ GFS Storage
                                                           Server #3
 

That frontend server gets a readdir request for a directory which is
stored across several of the storage servers.  It has to return a
cookie.  It will get that cookie back from the client at some unknown
later time (possibly after the server has rebooted).  So their solution
is to return a cookie from one of the storage servers, plus some kind of
node id in the top bits so they can remember which server it came from.

(I don't know much about gluster, but I think that's the basic idea.)

I've assumed that users of directory cookies should treat them as
opaque, so I don't think what gluster is doing is correct.  But on the
other hand they are defined as integers and described as offsets here
and there.  And I can't actually think of anything else that would work,
short of gluster generating and storing its own cookies.

> Because if it were running
> a kernel-side NFS server, it would be sufficient to use an nfs export
> option.
> 
> A client which mounts a "gluster file system" is also doing this via
> NFSv3, right?  Or are they using their own protocol?  If they are
> using their own protocol, why can't they encode the node ID somewhere
> else?
> 
> So this a correct picture of what is going on:
> 
>                                                   /------ GFS Storage
>                                                  /        Server #1
>   GFS Cluster     NFS V3      GFS Cluster      -- NFS v3
>   Client        <--------->   Frontend Server  ---------- GFS Storage
>                                                --         Server #2
>                                                  \
>                                                   \------ GFS Storage
>                                                           Server #3
> 
> 
> And the reason why it needs to use the high bits is because when it
> needs to coalesce the results from each GFS Storage Server to the GFS
> Cluster client?
> 
> The other thing that I'd note is that the readdir cookie has been
> 64-bit since NFSv3, which was released in June ***1995***.  And the
> explicit, stated purpose of making it be a 64-bit value (as stated in
> RFC 1813) was to reduce interoperability problems.  If that were the
> case, are you telling me that Sun (who has traditionally been pretty
> good worrying about interoperability concerns, and in fact employed
> the editors of RFC 1813) didn't get this right?  This seems
> quite.... surprising to me.
> 
> I thought this was the whole point of the various NFS interoperability
> testing done at Connectathon, for which Sun was a major sponsor?!?  No
> one noticed?!?

Beats me.  But it's not necessarily easy to replace clients running
legacy applications, so we're stuck working with the clients we have....

The linux client does remap the server-provided cookies to small
integers, I believe exactly because older applications had trouble with
servers returning "large" cookies.  So presumably ext4-exporting-Linux
servers aren't the first to do this.

I don't know which client versions are affected--Connectathon's next
week and I'll talk to people and make sure there's an ext4 export with
this turned on to test against.

--b.
