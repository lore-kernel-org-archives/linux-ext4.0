From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/5] Miklos's vfs/nfs/ext4 patches in the ext4.git tree
Date: Tue, 29 Mar 2016 16:12:55 -0400
Message-ID: <20160329201255.iux52klnrwfxsxpk@floor.thefacebook.com>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
 <CA+icZUUCF5-2YFkCeMze5Tsd-xynvmNBjTA8Qj7nE4LoCTa2-w@mail.gmail.com>
 <20160328140222.alfdic6nvdt3rpmf@floor.thefacebook.com>
 <20160329171523.GC6207@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, <jaegeuk@kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160329171523.GC6207@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 29, 2016 at 01:15:23PM -0400, Theodore Ts'o wrote:
> On Mon, Mar 28, 2016 at 10:02:22AM -0400, Chris Mason wrote:
> > > 
> > > Might be good to have...
> > > 
> > > "Btrfs: fix crash/invalid memory access on fsync when using overlayfs"
> > > 
> > > ...also in this series.
> > 
> > Yeah, I've been waiting on Miklos' patch to push the corresponding btrfs
> > fix.  I can do it separately or it can go in here too.  Either way is
> > fine with me.
> 
> I wasn't cc'ed on this patch and the only version I can find has a
> mangled e-mail address for Filipe Manana.  If you can send me the
> patch with your S-o-B, I'd be happy to include it in a push to Linus.

Thanks Ted, it'll be easiest to have all the deps in one place.

https://patchwork.kernel.org/patch/8634801/mbox/

(I can forward a copy if that doesn't work)

chris
