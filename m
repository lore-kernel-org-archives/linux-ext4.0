From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET,GET}FLAGS operations
Date: Thu, 06 Oct 2011 13:21:08 +0400
Message-ID: <87ty7m327v.fsf@dmbot.sw.ru>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org> <1316357699-22692-2-git-send-email-dmonakhov@openvz.org> <1317820840.2226.12.camel@doink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: aelder@sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1317820840.2226.12.camel@doink>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 5 Oct 2011 08:20:40 -0500, Alex Elder <aelder@sgi.com> wrote:
> On Sun, 2011-09-18 at 18:54 +0400, Dmitry Monakhov wrote:
> > Add two new operations:
> > - getattr: ioctl(fd, EXT2_IOC_GETFLAGS, &fl)
> > - setattr: ioctl(fd, EXT2_IOC_SETFLAGS, &random_flags)
> > By default IOC_SET_SETFLAGS has zero probability because
> > it may produce inodes with APPEND or IMMUTABLE flags which
> > are not deletable by default. Let's assumes that one who
> > enable it knows how to delete such inodes.
> > For example like follows:
> > find $TEST_PATH -exec chattr -i -a {} \;
> > rm -rf $TEST_PATH
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> I have a question below.  I think this is probably
> a good addition, though it should be made so it
> works for more than EXTx.
> 
> If I understand the way it would be used, this will
> simply be another operation that gets randomly performed
> by fsstress while it operates, right?
> 
> I have not done any testing with this yet.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> . . .
> 
> > @@ -1729,6 +1738,58 @@ setxattr_f(int opno, long r)
> >  }
> >  
> >  void
> > +getattr_f(int opno, long r)
> > +{
> > +#ifdef HAVE_EXT2_INCLUDE
> > +	int		fd;
> > +	int		e;
> > +	pathname_t	f;
> > +	uint		fl;
> > +	int		v;
> > +
> > +	init_pathname(&f);
> > +	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
> > +		append_pathname(&f, ".");
> 
> I don't understand the purpose of appending a "." to the
> end of the path.  Do you intend to just use "." if
> no other file matches?  (That may not be a good thing to
> do--it might not be testing the intended target.)
Yes just "." will be used. and infact i've copied that chunk from
chown_f, and similar approach is used for att_remove_f, attr_set_f
and setxattr_f operations. And in fact i'm not quite agree that they
are not independent, the only point they are connected is parent dir,
which IMHO acceptable in this case because operations result in inode
metadata changes only, w/o changing parent dir.
>   
> Or are you intending to append "/." so for a directory
> its "." link gets used in the open?  If so that's not
> what this does (it simply makes "a/b/x" become "a/b/x."). 
> Same comments apply to setattr_f().
> 
> > +	fd = open_path(&f, O_RDWR);
> > +	e = fd < 0 ? errno : 0;
> > +	check_cwd();
> > +
> > +	e = ioctl(fd, EXT2_IOC_GETFLAGS, &fl);
> > +	if (v)
> > +		printf("%d/%d: getattr %s %u %d\n", procid, opno, f.path, fl, e);
> > +	free_pathname(&f);
> > +	close(fd);
> > +#endif
> > +}
> > +
> > +void
> > +setattr_f(int opno, long r)
> > +{
> 
> 
