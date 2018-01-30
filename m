From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] inode->i_version rework for v4.16
Date: Tue, 30 Jan 2018 10:15:43 -0500
Message-ID: <20180130151543.GB8351@thunk.org>
References: <1517228795.5965.24.camel@redhat.com>
 <CA+55aFxXg8JprOwfm0qCm4VkkM8cPM38YMvpkf3gBJq3bSJwPw@mail.gmail.com>
 <1517313948.3658.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        xfs <linux-xfs@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517313948.3658.8.camel@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 30, 2018 at 07:05:48AM -0500, Jeff Layton wrote:
> 
> I want to make sure I understand what's actually broken here thoug. Is
> it only broken when the two values are more than 2**63 apart, or is
> there something else more fundamentally wrong here?

The other problem is that returning a s64 (or a u64) is extremely
inefficient on a 32-bit platform.  So in general, it's better to avoid
returning a 64-bit type unless it's really necessary....

						- Ted
