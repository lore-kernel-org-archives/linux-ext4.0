From: Jan Kara <jack@suse.cz>
Subject: Re: [GIT PULL] Ext3, reiserfs, udf & isofs fixes
Date: Mon, 9 Sep 2013 16:12:55 +0200
Message-ID: <20130909141255.GD1612@quack.suse.cz>
References: <20130905195802.GA9260@quack.suse.cz>
 <CA+55aFytAMNADORn4FfUO620OvLdiMRNVhYbVuCFnWgo4kpvjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFytAMNADORn4FfUO620OvLdiMRNVhYbVuCFnWgo4kpvjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 06-09-13 09:11:18, Linus Torvalds wrote:
> On Thu, Sep 5, 2013 at 12:58 PM, Jan Kara <jack@suse.cz> wrote:
> >
> > udf/isofs changes to refuse mounting fs rw instead of mounting it
> > ro automatically which makes eject button work as expected for all media (see
> > the changelog for why userspace should be ok with this change).
> 
> Pulled. However, these are kind of odd.
> 
> For trying _remount_ something read-only, isofs returns the logical
> EROFS error code.
> 
> But for trying to mount it in the first place, it returns EACCES,
> which sounds insane. It's not a permission problem - no amount of
> permissions will ever make it work.
> 
> UDF always does EACCES, regardless of mount/remount.
> 
> Is there some fundamental reason for the insane error code? Does user
> space do the wrong thing if we were to just always return "EROFS"
> which makes much more sense?
  So I personally like EROFS more as well. However blkdev_get_by_path()
(which is what mount(2) uses) returns EACCES if the device is read-only and
FMODE_WRITE was requested. Also the manpage for mount(2) talks about
EACCES when RW mount of read-only device was requested and doesn't mention
EROFS at all.

Now mount(8) handles both EROFS and EACCES the same way but I wanted to
stay on the safer side in case someone uses mount(2) directly so I used
more common EACCES.

I can create a separate patch changing all EACCES return values in this
area to EROFS but I'm not sure it is worth the possible hassle with
userspace...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
