From: Johannes Stezenbach <js@sig21.net>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Wed, 27 Jul 2016 13:58:43 +0200
Message-ID: <20160727115843.GA23786@sig21.net>
References: <20160718105707.GA4253@sig21.net>
 <20160718133843.GA26664@thunk.org>
 <20160718141723.GA8809@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160718141723.GA8809@sig21.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 18, 2016 at 04:17:23PM +0200, Johannes Stezenbach wrote:
> On Mon, Jul 18, 2016 at 09:38:43AM -0400, Theodore Ts'o wrote:
> > On Mon, Jul 18, 2016 at 12:57:07PM +0200, Johannes Stezenbach wrote:
> > > 
> > > I'm running 4.7.0-rc7 with ext4 on lvm on dm-crypt on SSD
> > > and out of the blue on idle machine the following error
> > > message appeared:
> > > 
> > > [373851.683131] EXT4-fs (dm-3): error count since last fsck: 1
> > > [373851.683151] EXT4-fs (dm-3): initial error at time 1468438194: dx_probe:740: inode 22288562
> > > [373851.683158] EXT4-fs (dm-3): last error at time 1468438194: dx_probe:740: inode 22288562
> > > 
> > > inode 22288562 is a directory with ~800 small files in it,
> > > but AFAICT nothing was accessing it, no cron job running etc.
> > > No further error message was logged.  Accessing the directory
> > > and the files in it also gives no further errors.

FWIW, now with 4.7.0 and errors=remount-ro it just happened again
during git update (actually "repo sync -ld" of AOSP/cm
repository).  Again a directory with 321 small files.
ls on ro fs after the error listed the directory without problems.
Fsck fixed wrong inode and wrong free block count.
ls after fsck still listed the directory and "git status"
reported it as clean.

[72173.126740] EXT4-fs error (device dm-3): dx_probe:740: inode #12327817: comm git: Directory index failed checksum
[72173.131346] Aborting journal on device dm-3-8.
[72173.135884] EXT4-fs (dm-3): Remounting filesystem read-only

Since I upgraded the RAM from 4G to 8G not long ago I
suspect it could be the root of the issue, although
this RAM was taken from another machine (which I had
upgraded from 4G to 12G and now downgraded to 8G) where it
worked for ~2 years, also with AOSP stuff.  Sigh...


Johannes
