From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH] fs: push sync_filesystem() down to the
 file system's remount_fs()
Date: Thu, 13 Mar 2014 16:28:23 +0000
Message-ID: <1394728103.2767.32.camel@menhir>
References: <20140313073936.GA14663@infradead.org>
	<1394720456-16629-1-git-send-email-tytso@mit.edu>
	<20140313162319.GA504@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, Anders Larsen <al@alarsen.net>,
        linux-mtd@lists.infradead.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Petr Vandrovec <petr@vandrovec.name>,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-cifs@vger.kernel.org,
        linux-fsdevel@thunk.org, cluster-devel@redhat.com,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Evgeniy Dushistov <dushistov@mail.ru>,
        Kees Cook <keescook@chromium.org>, fuse-devel@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
        linux-nilfs@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-nfs@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org,
        Adrian Hunter <ad
To: Jan Kara <jack@suse.cz>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20140313162319.GA504@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi,

On Thu, 2014-03-13 at 17:23 +0100, Jan Kara wrote:
> On Thu 13-03-14 10:20:56, Ted Tso wrote:
> > Previously, the no-op "mount -o mount /dev/xxx" operation when the
>                                   ^^remount
> 
> > file system is already mounted read-write causes an implied,
> > unconditional syncfs().  This seems pretty stupid, and it's certainly
> > documented or guaraunteed to do this, nor is it particularly useful,
> > except in the case where the file system was mounted rw and is getting
> > remounted read-only.
> > 
> > However, it's possible that there might be some file systems that are
> > actually depending on this behavior.  In most file systems, it's
> > probably fine to only call sync_filesystem() when transitioning from
> > read-write to read-only, and there are some file systems where this is
> > not needed at all (for example, for a pseudo-filesystem or something
> > like romfs).
>   Hum, I'd avoid this excercise at least for filesystem where
> sync_filesystem() is obviously useless - proc, debugfs, pstore, devpts,
> also always read-only filesystems such as isofs, qnx4, qnx6, befs, cramfs,
> efs, freevxfs, romfs, squashfs. I think you can find a couple more which
> clearly don't care about sync_filesystem() if you look a bit closer.
> 
>
> 								Honza

I guess the same is true for other file systems which are mounted ro
too. So maybe a check for MS_RDONLY before doing the sync in those
cases?

Steve.
