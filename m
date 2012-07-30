From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 10/10 v1][RESEND] ext4: add two tracepoints in
 punching hole
Date: Mon, 30 Jul 2012 10:15:52 +0800
Message-ID: <20120730021551.GB21674@gmail.com>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
 <1342943986-12413-11-git-send-email-wenqing.lz@taobao.com>
 <alpine.LFD.2.00.1207271540350.23525@vpn-10-43.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207271540350.23525@vpn-10-43.rdu.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2012 at 03:43:46PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Sun, 22 Jul 2012, Zheng Liu wrote:
>=20
> > Date: Sun, 22 Jul 2012 15:59:46 +0800
> > From: Zheng Liu <gnehzuil.liu@gmail.com>
> > To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> > Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com, wenqing.lz@=
taobao.com
> > Subject: [RFC][PATCH 10/10 v1][RESEND] ext4: add two tracepoints in=
 punching
> >     hole
> >=20
> > From: Zheng Liu <wenqing.lz@taobao.com>
> >=20
> > This patch adds two tracepoints in ext4_ext_punch_hole.
>=20
> Hi,
>=20
> the trace_ext4_ext_punch_hole_enter() looks good, but I am not so
> sure about the trace_ext4_ext_punch_hole_exit() trace point. What is
> the point of having this tracepoint ? The only thing it adds to the
> information we already have is return value of the function and
> that's something we'll know anyway, right ?
>=20
> Is there any special reason for having this ? If not, I think it can
> be removed and trace_ext4_ext_punch_hole_enter() can be renamed to
> trace_ext4_ext_punch_hole() to match the naming conventions of other
> ext4 tracepoints.

Hi Lukas,

The trace_ext4_ext_punch_hole_exit() is added because we do the same
thing in ext4_truncate().  In this function we call *_truncate_enter()
and *_truncate_exit().  There is not other special reason for adding it=
=2E
So I can change it according to your advice in next version.

Regards,
Zheng

> >=20
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/extents.c           |    3 ++
> >  include/trace/events/ext4.h |   53 +++++++++++++++++++++++++++++++=
++++++++++++
> >  2 files changed, 56 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 2a526b4..0fb4ff5 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4529,6 +4529,8 @@ int ext4_ext_punch_hole(struct file *file, lo=
ff_t offset, loff_t length)
> >  	loff_t first_page_offset, last_page_offset;
> >  	int credits, err =3D 0;
> > =20
> > +	trace_ext4_ext_punch_hole_enter(inode, offset, length);
> > +
> >  	mutex_lock(&inode->i_mutex);
> > =20
> >  	/* No need to punch hole beyond i_size */
> > @@ -4663,6 +4665,7 @@ out:
> >  	ext4_journal_stop(handle);
> >  error:
> >  	mutex_unlock(&inode->i_mutex);
> > +	trace_ext4_ext_punch_hole_exit(inode, offset, length, err);
> >  	return err;
> >  }
> >  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fi=
einfo,
> > diff --git a/include/trace/events/ext4.h b/include/trace/events/ext=
4.h
> > index 5c17592..583f066 100644
> > --- a/include/trace/events/ext4.h
> > +++ b/include/trace/events/ext4.h
> > @@ -1312,6 +1312,59 @@ TRACE_EVENT(ext4_fallocate_exit,
> >  		  __entry->ret)
> >  );
> > =20
> > +TRACE_EVENT(ext4_ext_punch_hole_enter,
> > +	TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
> > +
> > +	TP_ARGS(inode, offset, len),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	dev_t,	dev			)
> > +		__field(	ino_t,	ino			)
> > +		__field(	loff_t,	offset			)
> > +		__field(	loff_t, len			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->dev	=3D inode->i_sb->s_dev;
> > +		__entry->ino	=3D inode->i_ino;
> > +		__entry->offset	=3D offset;
> > +		__entry->len	=3D len;
> > +	),
> > +
> > +	TP_printk("dev %d,%d ino %lu offset %lld len %lld",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  (unsigned long) __entry->ino,
> > +		  __entry->offset, __entry->len)
> > +);
> > +
> > +TRACE_EVENT(ext4_ext_punch_hole_exit,
> > +	TP_PROTO(struct inode *inode, loff_t offset,
> > +		 loff_t len, int err),
> > +
> > +	TP_ARGS(inode, offset, len, err),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	dev_t,	dev			)
> > +		__field(	ino_t,	ino			)
> > +		__field(	loff_t,	offset			)
> > +		__field(	loff_t,	len			)
> > +		__field(	int,	err			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->dev	=3D inode->i_sb->s_dev;
> > +		__entry->ino	=3D inode->i_ino;
> > +		__entry->offset	=3D offset;
> > +		__entry->len	=3D len;
> > +		__entry->err	=3D err;
> > +	),
> > +
> > +	TP_printk("dev %d,%d ino %lu offset %lld len %lld err %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  (unsigned long) __entry->ino,
> > +		  __entry->offset, __entry->len, __entry->err)
> > +);
> > +
> >  TRACE_EVENT(ext4_unlink_enter,
> >  	TP_PROTO(struct inode *parent, struct dentry *dentry),
> > =20
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
