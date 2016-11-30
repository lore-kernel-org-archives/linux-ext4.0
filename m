From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Wed, 30 Nov 2016 16:00:35 -0500
Message-ID: <20161130210035.kqiyf6ifrza36w5l@thunk.org>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
 <CA+POJK10M3_GhP_Ge4qkQF4gSNMUXVr5kem9Ak4EDmVRvRUg7g@mail.gmail.com>
 <f9bc005b-4e25-d705-e091-5f930e4246b1@nod.at>
 <CAKpBdu1+k94WmwxeZ2Hyu5=ifNprPA0YedRm2xps-ooyVHTwhg@mail.gmail.com>
 <87d9b3aa-684d-856a-0dcd-f960923f2484@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joe Richey <joerichey@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, kzak@redhat.com,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d9b3aa-684d-856a-0dcd-f960923f2484@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 29, 2016 at 10:59:28PM +0100, Richard Weinberger wrote:
> Thanks for your quick response!
> I hoped you had already some code, but having a decent design document
> is also nice. I'm eager to read it.

To be clear, the design document which Joe is working on is only
addressing a new way of transforming a password or passphrase into a
key.  Previouly, we used PBKDF2 using a per-file system salt.  (Well,
that's what e4crypt used.  Android used a completely random key that
was protected by the user's pin or passphrase --- possibly stored in
ARM TrustZone on some handsets.)

The goal is to come up with something that works well with
single-signon (i.e., can be integrated into PAM), as well as removable
storage devices and directories that are protected by some passphrase
other than the user's login for those people who are especially
security conscious.  It should also handle the password change case.

It probably won't cover key recovery initially (that's probably more
of a V2 or V3 thing), but the design should accomodate that.

> Do you also plan to address d/page cache related issues?
> i.e. when two users are logged into the system user rw
> is able to see decrypted file names and contents in /home/dags/
> if user dags installs a key and accessed a file.
> 
> Or files in /home/dags/ are still readable even after
> user dags purged the key.
> 
> The tool could play games with CLONE_NEWNS to hide directories.
> To provide a correct "logout" we could expose shrink_dcache_parent()
> to usespace such that the emerging tool can purge the key and flush
> the dcache on the encrypted directory. But I fear exposing shrink_dcache_parent()
> is not a good idea. :-)

Right now, the best thing I can suggest is "echo 3 >
/proc/sys/vm/drop_caches" in executed PAM module on when the user
terminates their login session.  If you're really paranoid, make sure
all processes running under the user's pid are terminated with extreme
prejudice first.

We don't have a good solution for a high security directory (e.g.,
$HOME/bitcoin) where you want to drop its keys and cached data in the
middle of a user login session today.  The drop_caches solution
doesn't work well on a time sharing system since it drops *all*
caches.  Also, if you have anything keeping pages or file descriptors,
etc., pinned, the drop_cache solution won't address that either.

I suspect any realistic solution will require changes that will need
to be run by the Al Viro and the MM folks, and may require adding
something like BSD's revoke(2) functionality.  To be honest, this
isn't a particularly high priority item at the moment for me or
Michael's team at the moment, so if someone wants to work on it, feel
free.  As they say, high quality patches are always accepted.  :-)

Cheers,

					- Ted
