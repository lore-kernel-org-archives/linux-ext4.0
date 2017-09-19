From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: mounting with lazytime doesn't work on ext4
Date: Tue, 19 Sep 2017 16:55:37 +0200
Message-ID: <20170919145537.GA211@x4>
References: <20170918192644.GA232@x4>
 <20170919083506.GA233@x4>
 <20170919144617.wh4raizggvwjpolg@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:39304 "EHLO
        mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdISOzk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Sep 2017 10:55:40 -0400
Content-Disposition: inline
In-Reply-To: <20170919144617.wh4raizggvwjpolg@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2017.09.19 at 16:46 +0200, Lukas Czerner wrote:
> On Tue, Sep 19, 2017 at 10:35:06AM +0200, Markus Trippelsdorf wrote:
> > On 2017.09.18 at 21:26 +0200, Markus Trippelsdorf wrote:
> > > I switched back to ext4 yesterday, because my btrfs fs got corrupted.
> > > However mounting with lazytime doesn't work, neither specifying it in
> > > /etc/fstab nor a manual remount. It looks like the option is simply
> > > ignored.
> > > 
> > > Strace shows, e.g.:
> > > 
> > >  # mount -o lazytime /boot
> > > mount("/dev/sdc2", "/boot", "ext4", MS_LAZYTIME, NULL) = 0 
> > > EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null) 
> > > /dev/sdc2 on /boot type ext4 (rw,relatime,data=ordered)
> > > 
> > >  # mount -o remount,lazytime /var
> > > mount("/dev/sdb2", "/var", 0x12c4460, MS_REMOUNT|MS_NOATIME|MS_LAZYTIME, NULL) = 0 
> > > EXT4-fs (sdb2): re-mounted. Opts: (null)
> > > /dev/sdb2 on /var type ext4 (rw,noatime,data=ordered)
> > > 
> > > When I set "sb->s_flags |= MS_LAZYTIME;" unconditionally in
> > > fs/ext4/super.c:5057 (just deleting the if statement), then lazytime
> > > gets used when I remount.
> > > 
> > > I'm running the latest git tree (4.14.0-rc1).
> > 
> > The following patch seems to fix the issue for remounts:
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index 54059b142d6b..d0b386706c5b 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -2322,6 +2322,9 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
> >  	if (err)
> >  		return err;
> >  
> > +	if (mnt_flags & MS_LAZYTIME)
> > +		sb_flags |= MS_LAZYTIME;
> > +
> >  	down_write(&sb->s_umount);
> >  	if (ms_flags & MS_BIND)
> >  		err = change_mount_flags(path->mnt, ms_flags);
> > @@ -2809,6 +2812,8 @@ long do_mount(const char *dev_name, const char __user *dir_name,
> >  		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
> >  	if (flags & SB_RDONLY)
> >  		mnt_flags |= MNT_READONLY;
> > +	if (flags & MS_LAZYTIME)
> > +		mnt_flags |= MS_LAZYTIME;
> 
> Hi,
> 
> this is definitely not right. Currently it seems that MS_LAZYTIME is
> supposed to be per sb option, even though I do not see a reason why it
> should not be per mnt options, in fact I'd prefer that.
> 
> However the problem happened when
> e462ec50cb5fad19f6003a3d8087f4a0945dd2b1 switched from masking out per
> mnt flags to masking in per sb flags. However David missed SB_LAZYFLAG.
> The fix should be easy like this:

Yes. I already send the identical patch. Please see:
https://lkml.org/lkml/2017/9/19/186

-- 
Markus
