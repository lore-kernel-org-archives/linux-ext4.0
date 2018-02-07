From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv2 1/1] ext4: don't put symlink in pagecache into highmem
Date: Tue, 6 Feb 2018 21:16:17 -0500
Message-ID: <20180207021617.GD1977@thunk.org>
References: <20180206190938.172792-1-jinqian@android.com>
 <20180206203953.GC18045@kroah.com>
 <20180206231149.GC1977@thunk.org>
 <20180206233809.GA159960@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Jin Qian <jinqian@android.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jin Qian <jinqian@google.com>,
        stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180206233809.GA159960@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 06, 2018 at 03:38:09PM -0800, Eric Biggers wrote:
> I don't think backporting this change for other filesystems is particularly
> important, since if I understand correctly, the reasons that Al made the change
> originally were:
> 
> - to allow following symlinks in RCU mode, but that's not implemented in old
>   kernels

Yup.

> - to prevent a process from using up all kmaps and deadlocking the system, which
>   I'm not sure is a real problem (someone would need to try to put together a
>   reproducer), but if so it would probably just be a local device of service.

.. and *that's* only a problem on 32-bit systems.  And aside from
Android, it's unclear to me how much we need to support 32-bit systems
on upstream LTS kernels.  I suppose there might be Rasperry PI's which
are 32-bits and which might want to use btrfs.  Personally I'm not
sure we should care all that much, but others who care more about LTS
kernels and 32-bit systems might have a different opinion.

> Also if we actually backported the full commit there are follow-on fixes such as
> e8ecde25f5e that would be needed as well but might be missed.

Good point.

					- Ted
