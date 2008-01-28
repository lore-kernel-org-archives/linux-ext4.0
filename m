From: Andreas Dilger <adilger@sun.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Mon, 28 Jan 2008 13:59:19 -0700
Message-ID: <20080128205919.GW18433@webber.adilger.int>
References: <20080124211728.GA24900@webber.adilger.int>
	<n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu>
	<n7x1w82nf7m.fsf@sor.suse.de> <20080128153802.GB17752@mit.edu>
	<479E08D5.3040609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hvogel@suse.de, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <esandeen@redhat.com>,
	Matthias Koenig <mkoenig@suse.de>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <ext3-users-bounces@redhat.com>
In-reply-to: <479E08D5.3040609@redhat.com>
Resent-message-id: <20080129203143.GC20490@webber.adilger.int>
Content-disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Jan 28, 2008  10:54 -0600, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Mon, Jan 28, 2008 at 04:26:53PM +0100, Matthias Koenig wrote:
> >>> Patch6:         e2fsprogs-mdraid.patch
> >>>
> >>> This apparently adds a new environment variable,
> >>> BLKID_SKIP_CHECK_MDRAID, which forces blkid to not detect mdraid
> >>> devices.  I'm not sure why.
> >> Workaround for people having stale RAID signature on their disk:
> >> https://bugzilla.novell.com/show_bug.cgi?id=100530
> > 
> > Hmm... there's got to be a better way around this.
> 
> Won't help existing block devices, but it'd be nice to have a common
> library which could be called @ mkfs time to wipe out all known
> signatures...
> 
> mkfs.xfs tries to do this, but it'd be silly to duplicate in every mkfs.

Well, blkid already has a way to _detect_ a lot of filesystem signatures,
so it might be relatively easy to exploit the type_array[] entries to have
it zap out all of these blocks.  That said, the majority of them are in
the first 68kB of the filesystem (mdraid excluded) so it shouldn't be too
hard to zero them out.  Let's hope nobody ever uses "0x00000000" as magic.

mke2fs already tries to do this, though I notice:
- the zap_sector() call will skip the entire write if there is a BSD bootblock,
  instead of skipping only the first sector(s) and overwriting the rest...
  Since I don't know much about BSD bootblocks, I don't know what the right
  behaviour is, but I can guess we still want to zero out 4-68kB (or whatever).
- it only overwrites up to sector 8 (4kB) and not further into the disk to
  catch e.g. reiserfs superblocks.  Usually it will overwrite this anyways
  (GDT, bitmaps, inode table), but in some rare cases it might not.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
