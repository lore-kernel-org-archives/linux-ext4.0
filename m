From: "Kani, Toshi" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH 2/2] ext4, dax: set ext4_dax_aops for dax files
Date: Tue, 11 Sep 2018 18:41:26 +0000
Message-ID: <b26a520cba402f129314eabef78d2c2a2da4a1b0.camel@hpe.com>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
 <20180911154246.6844-3-toshi.kani@hpe.com>
 <CAPcyv4iEZ7q0MV7n-_eovrJw_U9S3=pkY_nYwtw1jSBS7vPqCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "tytso-3s7WtUTddSA@public.gmane.org" <tytso-3s7WtUTddSA@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org" <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4iEZ7q0MV7n-_eovrJw_U9S3=pkY_nYwtw1jSBS7vPqCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <EFF6AD399147714C9686656AC13320F4-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Tue, 2018-09-11 at 11:15 -0700, Dan Williams wrote:
> On Tue, Sep 11, 2018 at 8:42 AM, Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:
> > Sync syscall to an existing DAX file needs to flush processor cache,
> > but it does not currently.  This is because 'ext4_da_aops' is set to
> > address_space_operations of existing DAX files, instead of 'ext4_dax_aops',
> > since S_DAX flag is set after ext4_set_aops() in the open path.
> > 
> >   New file
> >   --------
> >   lookup_open
> >     ext4_create
> >       __ext4_new_inode
> >         ext4_set_inode_flags   // Set S_DAX flag
> >       ext4_set_aops            // Set aops to ext4_dax_aops
> > 
> >   Existing file
> >   -------------
> >   lookup_open
> >     ext4_lookup
> >       ext4_iget
> >         ext4_set_aops          // Set aops to ext4_da_aops
> >         ext4_set_inode_flags   // Set S_DAX flag
> > 
> > Change ext4_iget() to call ext4_set_inode_flags() before ext4_set_aops().
> > 
> > Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> 
> Same format nit:
> 
> Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Will do.

> > Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> > Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> > Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> > ---
> >  fs/ext4/inode.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 775cd9b4af55..93cbbb859c40 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4998,6 +4998,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >         if (ret)
> >                 goto bad_inode;
> > 
> > +       ext4_set_inode_flags(inode);
> > +
> 
> Hmm, does this have unintended behavior changes?
> 
> I notice that there are some checks for flags "IS_APPEND(inode) ||
> IS_IMMUTABLE(inode)" *before* the call to ext4_set_inode_flags(). I
> didn't look too much deeper at whether those checks are bogus, but it
> would seem safer to do something like this for a lower risk fix.
> 
> Thoughts?

Good catch!  Agreed.

Thanks!
-Toshi
