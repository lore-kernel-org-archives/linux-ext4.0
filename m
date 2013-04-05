From: "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: [PATCH, RFC V3] ext3: add ioctl to force 32-bit hashes from
 indexed dirs
Date: Fri, 5 Apr 2013 19:28:21 -0400
Message-ID: <20130405232821.GA15810@pad.fieldses.org>
References: <5154AAB4.2000701@redhat.com>
 <5159A8D5.1000204@redhat.com>
 <20130401181718.GB22443@thunk.org>
 <5159D03F.5000606@redhat.com>
 <20130401190804.GD22443@thunk.org>
 <5159E4AC.7050307@redhat.com>
 <20130401200052.GA24097@thunk.org>
 <5159E88F.8030704@redhat.com>
 <307C00EE-45DE-48A4-9FB7-3F164B51A524@redhat.com>
 <1365203125.15177.33.camel@jesse>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anand Avati <avati@redhat.com>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, gluster-devel@nongnu.org,
	jra@samba.org
To: Andrew Bartlett <abartlet@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881Ab3DEX3N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 19:29:13 -0400
Content-Disposition: inline
In-Reply-To: <1365203125.15177.33.camel@jesse>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 06, 2013 at 10:05:25AM +1100, Andrew Bartlett wrote:
> On Mon, 2013-04-01 at 13:34 -0700, Anand Avati wrote:
> > On Apr 1, 2013, at 1:05 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > > 
> > > Meh, let's just keep it simple then.  And I'd really like to know if
> > > gluster still even needs this, or if their new scheme will work instead,
> > 
> > As of this morning the new d_off transformation (Zach's idea) is merged in gluster. We had to put in some kind of ext4 awareness, and the "more complex" d_off transformation (which is finally working properly after fixing some minor issues) seemed better than calling ioctls by detecting the backend is ext4.
> > 
> > > in  which case we should drop it - but Samba made noise about needing it too,
> > > though I've not seen specifics, so I hate to merge it "just in case."
> > 
> > Yes, I too saw comments from Andrew Bartlett of the Samba team. It
> > appeared to be the case that Samba could only present 32bit cookies
> > while ext4 was now returning larger cookies (somewhat like the old
> > NFSv2 clients problem?). This ioctl would be useful there I guess,
> > bring it "in par" with knfsd's abilities of expressing desire for
> > 32bit cookies? However, for knfsd legacy requirements, FMODE_32BITHASH
> > is in generic VFS. But for a userspace file server, it would need to
> > first gain the knowledge of which filesystems in the world actually
> > present large cookies, and for the subset which support smaller
> > cookies, issue filesystem specific ioctls() in their own specific
> > ways.
> > 
> > Wouldn't it be "fair" to treat userspace file servers as equals, and
> > provide a generic FS independent ioctl to set the common
> > FMODE_32BITHASH flag on any dir fd? Think of it as a way of extending
> > the "pointer access" to file->f_mode which NFS exercises, up to
> > userspace?
> 
> If 32-bit cookies are baked into current-generation NFS, even if Samba
> doesn't take this up, wouldn't
> http://sourceforge.net/apps/trac/nfs-ganesha/ need it just the same?

I guess ganesha could use tricks similar to gluster's and throw out the
low bits of 64-bit cookies.

For knfsd I've been telling people they should either

	- fix their clients (the protocol *does* define cookies to be 64
	  bits, and the Linux client has shown it's practical to remap
	  64-bit cookies to 32-bit cookies if necessary for applications
	  using 32-bit interfaces), or
	- fix applications to use 64-bit interfaces, or
	- just turn off dir_index: hopefully the fact that they've been
	  happily using ext4 without seeing hash collisions means they
	  aren't using very large directories, hence can live without
	  dir_index.

knfsd is still returning 32-bit cookies to v2 clients (that's the
protocol), but I doubt v2 support is very critical for Ganesha.

--b.
