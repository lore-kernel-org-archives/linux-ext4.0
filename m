From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCHv2 1/1] ext4: don't put symlink in pagecache into highmem
Date: Tue, 6 Feb 2018 15:38:09 -0800
Message-ID: <20180206233809.GA159960@gmail.com>
References: <20180206190938.172792-1-jinqian@android.com>
 <20180206203953.GC18045@kroah.com>
 <20180206231149.GC1977@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jin Qian <jinqian@android.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jin Qian <jinqian@google.com>,
        stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206231149.GC1977@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 06, 2018 at 06:11:49PM -0500, Theodore Ts'o wrote:
> On Tue, Feb 06, 2018 at 12:39:53PM -0800, Greg KH wrote:
> > On Tue, Feb 06, 2018 at 11:09:37AM -0800, Jin Qian wrote:
> > > From: Jin Qian <jinqian@google.com>
> > > 
> > > partial backport from 21fc61c73c3903c4c312d0802da01ec2b323d174 upstream
> > > to v4.4 to prevent virt_to_page on highmem.
> >
> > Ted, any objection to this patch?
> 
> No objections with my ext4 hat on.
> 
> It should be noted though that this is a partial backport because it
> only fixes ext4, while Al's original upstream fix addressed a much
> larger set of file systems.  In the Android kernel the f2fs fix had
> been backported separately.  But for the upstream kernel, it *might*
> be the case that we should try backporting the original commit so that
> in case there is some other general purpose distribution decides (a)
> to base their system on 4.4, and (b) support a 32-bit kernel, they get
> the more general bug fixes which applies for btrfs, isofs, ocfs2, nfs,
> etc.
> 
> I haevn't been paying attention to what LTS kernels general purpose
> distro's are using, so I don't know how important this would be.  And
> if there are companies like Cloudflare which are using upstream LTS
> kernel, it seems unlikely they would want to use a 32-bit kernel,
> so.... shrug.  Greg, I'll let you decide if you want to backport the
> full commit or not.
> 
> (We had a similar discussion on the AOSP kernel, and came to the
> conclusion that we only needed to make the patch support ext4.  No one
> was going to test the other file systems besides ext4 and f2fs,
> anyway.  But the calculus might be different might be different for
> the general upstream LTS kernel.)
> 

Well, the main point of backporting this change is to fix symlink decryption on
32-bit systems.  So, it would be needed on both ext4 and f2fs.  Jin, it might be
a good idea to fix f2fs in this patch at well, since unlike the AOSP kernels,
the LTS kernels do not have the latest f2fs backported to them.

I don't think backporting this change for other filesystems is particularly
important, since if I understand correctly, the reasons that Al made the change
originally were:

- to allow following symlinks in RCU mode, but that's not implemented in old
  kernels

- to prevent a process from using up all kmaps and deadlocking the system, which
  I'm not sure is a real problem (someone would need to try to put together a
  reproducer), but if so it would probably just be a local device of service.

Also if we actually backported the full commit there are follow-on fixes such as
e8ecde25f5e that would be needed as well but might be missed.

Thanks,

- Eric
