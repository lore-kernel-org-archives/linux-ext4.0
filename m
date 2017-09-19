From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: mounting with lazytime doesn't work on ext4
Date: Tue, 19 Sep 2017 13:03:53 +0200
Message-ID: <20170919110353.GA233@x4>
References: <20170918192644.GA232@x4>
 <20170919110021.3yn6n4ot3whh6myi@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:43468 "EHLO
        mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdISLDy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Sep 2017 07:03:54 -0400
Content-Disposition: inline
In-Reply-To: <20170919110021.3yn6n4ot3whh6myi@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2017.09.19 at 13:00 +0200, Lukas Czerner wrote:
> On Mon, Sep 18, 2017 at 09:26:44PM +0200, Markus Trippelsdorf wrote:
> > I switched back to ext4 yesterday, because my btrfs fs got corrupted.
> > However mounting with lazytime doesn't work, neither specifying it in
> > /etc/fstab nor a manual remount. It looks like the option is simply
> > ignored.
> > 
> > Strace shows, e.g.:
> > 
> >  # mount -o lazytime /boot
> > mount("/dev/sdc2", "/boot", "ext4", MS_LAZYTIME, NULL) = 0 
> > EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null) 
> > /dev/sdc2 on /boot type ext4 (rw,relatime,data=ordered)
> > 
> >  # mount -o remount,lazytime /var
> > mount("/dev/sdb2", "/var", 0x12c4460, MS_REMOUNT|MS_NOATIME|MS_LAZYTIME, NULL) = 0 
> > EXT4-fs (sdb2): re-mounted. Opts: (null)
> > /dev/sdb2 on /var type ext4 (rw,noatime,data=ordered)
> > 
> > When I set "sb->s_flags |= MS_LAZYTIME;" unconditionally in
> > fs/ext4/super.c:5057 (just deleting the if statement), then lazytime
> > gets used when I remount.
> > 
> > I'm running the latest git tree (4.14.0-rc1).
> 
> Hi,
> 
> I can't really see the problem on my system (4.14.0-rc1)
> 
> # mount -o lazytime /dev/vdb /mnt/test
> # mount | grep vdb
> /dev/vdb on /mnt/test type ext4 (rw,relatime,lazytime,seclabel,data=ordered)
> 
> Log says:
> EXT4-fs (vdb): mounted filesystem with ordered data mode. Opts: lazytime
> 
> or even via remount
> 
> # mount /dev/vdb /mnt/test
> # mount | grep vdb
> /dev/vdb on /mnt/test type ext4 (rw,relatime,seclabel,data=ordered)
> # mount -o remount,lazytime /mnt/test
> # mount | grep vdb
> /dev/vdb on /mnt/test type ext4 (rw,relatime,lazytime,seclabel,data=ordered)
> 
> Log says:
> EXT4-fs (vdb): re-mounted. Opts: data=ordered,lazytime
> 
> This is probably because I have older version of util-linux that did
> now knew about MS_LAZYTIME so it passed "lazytime" option down to the
> filesystem. So we're definitelly missing something in kernel for this to
> work properly.
> 
> Indeed with newer version of util-linux, specifically the one containing
> commit v2.26-169-g8c7f073 I can reproduce.

Yes. It took me some time to figure out that this is a very recent Linux
regression (since commit e462ec50cb5). I've have send a simple patch to
fix the issue.

-- 
Markus
