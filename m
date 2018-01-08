From: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
Date: Mon, 8 Jan 2018 21:17:13 +0100
Message-ID: <20180108201713.rdfjn7j65cuqmwuo@kozik-lap>
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-20-jlayton@kernel.org>
 <CAJKOXPd8ojTjiGF3nKQKWtVrEsjWfjvg6rLL+RGnbu_SZMDu7g@mail.gmail.com>
 <1515416208.3486.14.camel@kernel.org>
 <CAJKOXPfv4eSERDiUuZuJ7KdpyGU0=Eqt_A+J6knp-FEW9BZoSw@mail.gmail.com>
 <1515418164.3486.18.camel@kernel.org>
 <20180108172928.aqndozcpljb73uj6@kozik-lap>
 <1515434419.3486.41.camel@kernel.org>
 <20180108183353.emiwsd4aic4gmytr@kozik-lap>
 <1515438929.3486.48.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, jack-l3A5Bk7waGM@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBo=C5=82nierkiewicz?=
        <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515438929.3486.48.camel-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 08, 2018 at 02:15:29PM -0500, Jeff Layton wrote:
> On Mon, 2018-01-08 at 19:33 +0100, Krzysztof Kozlowski wrote:
> > On Mon, Jan 08, 2018 at 01:00:19PM -0500, Jeff Layton wrote:
> > > On Mon, 2018-01-08 at 18:29 +0100, Krzysztof Kozlowski wrote:
> > 
> > (...)
> > 
> > > > > Ok, thanks. If you're seeing hangs then that might imply that we have
> > > > > some sort of excessive looping going on in the cmpxchg loops.
> > > > > 
> > > > > Could you apply the patch below and let me know if it causes either of
> > > > > the warnings to pop? That might at least point us in the right
> > > > > direction:
> > > > 
> > > > No new warnings with attached patch (except existing already lockdep:
> > > > "INFO: trying to register non-static key.").
> > > > 
> > > 
> > > Yeah, I saw that in the original logs and it looks unrelated (and
> > > harmless).
> > > 
> > > > Systemd timeouts on mounting /home but after entering rescue shell there
> > > > is no problem running mount /home:
> > > > 	Give root password for maintenance
> > > > 	(or press Control-D to continue): 
> > > > 	root@odroidxu3:~# mount /home
> > > > 	[  220.659331] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data mode. Opts: (null)
> > > > 
> > > 
> > > Ok, thanks for testing it. So I guess we can probably rule out excessive
> > > looping in those functions as the issue.
> > > 
> > > To make sure I understand the problem: When systemd tries to do the
> > > initial mount of /home (which is an ext4 filesystem), it hangs. But once
> > > it drops to the shell, it works, if you do the mount by hand.
> > > 
> > > Is that correct?
> > 
> > Yes, although it also timeouts on setting up /dev/ttySAC2 (serial
> > console).
> > 
> > > If so, then is it possible to trigger sysrq commands during the hanging
> > > mount attempt? Maybe you could use e.g. sysrq-l, sysrq-w, etc. to
> > > determine what it's blocking on?
> 
> (trimming the output)
> 
> Thanks. I don't really see anything obvious in that info,
> unfortunately. What we really need to do is find the systemd task
> performing the mount, and see what it's doing.

It's systemd 236.0-2 coming from Arch Linux for ARM. All packages are
updated.

> We do have one questionable bug in the NFS changes though. Does this
> patch help at all?

Patches do not change anything (I tried "SQUASH: nfs: fix i_version
increment when adding a request" and "SQUASH: ext4: use raw API for
xattr inode refcounts").

I tried again regular SDcard-root boot and it succeeded. Only nfsroot
fails.

Best regards,
Krzysztof


> 
> -------------------------------8<---------------------------------
> 
> SQUASH: nfs: fix i_version increment when adding a request
> 
> NFS treats this value as an opaque value with no flag, so we must
> increment it as such instead of using inode_inc_iversion.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nfs/write.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> index a03fbac1f88c..48837b6250e9 100644
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -755,7 +755,7 @@ static void nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
>  	spin_lock(&mapping->private_lock);
>  	if (!nfs_have_writebacks(inode) &&
>  	    NFS_PROTO(inode)->have_delegation(inode, FMODE_WRITE))
> -		inode_inc_iversion(inode);
> +		atomic64_inc(&inode->i_version);
>  	if (likely(!PageSwapCache(req->wb_page))) {
>  		set_bit(PG_MAPPED, &req->wb_flags);
>  		SetPagePrivate(req->wb_page);
> -- 
> 2.14.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
