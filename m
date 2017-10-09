From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] ext4/026: skip test if kernel does not support the
 ea_inode feature
Date: Mon, 9 Oct 2017 14:37:01 +0800
Message-ID: <20171009063701.GC10593@eguan.usersys.redhat.com>
References: <20171008192324.20477-1-tytso@mit.edu>
 <20171008214117.GU15067@dastard>
 <20171008215110.qxhel7nkcsifybu2@thunk.org>
 <20171008224010.GY15067@dastard>
 <CAOQ4uxgHY+yyOcFX2mtWHX3oz9rtSidLM1_Ni3q-Lw-DcnHxLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
        fstests <fstests@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgHY+yyOcFX2mtWHX3oz9rtSidLM1_Ni3q-Lw-DcnHxLA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 09, 2017 at 09:00:18AM +0300, Amir Goldstein wrote:
> On Mon, Oct 9, 2017 at 1:40 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sun, Oct 08, 2017 at 05:51:10PM -0400, Theodore Ts'o wrote:
> >> On Mon, Oct 09, 2017 at 08:41:17AM +1100, Dave Chinner wrote:
> >> > On Sun, Oct 08, 2017 at 03:23:24PM -0400, Theodore Ts'o wrote:
> >> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> >> > > ---
> >> > >  tests/ext4/026 | 3 ++-
> >> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> > >
> >> > > diff --git a/tests/ext4/026 b/tests/ext4/026
> >> > > index 94a737ce..ba77f36e 100755
> >> > > --- a/tests/ext4/026
> >> > > +++ b/tests/ext4/026
> >> > > @@ -53,7 +53,8 @@ _require_attrs
> >> > >  _require_ext4_mkfs_feature ea_inode
> >> > >
> >> > >  _scratch_mkfs_ext4 -O ea_inode >/dev/null 2>&1
> >> > > -_scratch_mount
> >> > > +_scratch_mount >/dev/null 2>&1 \
> >> > > + || _notrun "kernel doesn't support ea_inode feature on $FSTYP"
> >> >
> >> > Needs to be in a _requires check?
> >>
> >> There's only one test currently testing ea_inode at the moment, but
> >> sure, I can make it into a _requires check.
> >
> > I note there's a _require_ext4_mkfs_feature check above. Perhaps
> > just turn that into a _require_ext4_feature that checks both mkfs
> > and whether the kernel supports the functionality? That's typically
> > what we've done in the past - one _require rule to check all
> > aspects of support needed to use the feature...
> >

Agreed, I think we can make _require_ext4_bigalloc() more generic, turn
it into _require_scratch_ext4_feature(), and take use of
_require_ext4_mkfs_feature() in the new helper to do the userspace
check. And use the new helper in ext4/003 ext4/02[56] and ext4/306.

> 
> 
> At the time when I introduced _require_scratch_overlay_feature Eryu
> requested that I make it generic , so please hook
> _require_scratch_ext4_feature to the generic helper.

BTW, the generic helper is _require_scratch_feature().

Thanks,
Eryu

> Btw there is a cleanup patch factoring out
> _require_scratch_overlay_feature helper which has not been merged yet
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
