From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4 crypto: use dget_parent() in ext4_d_revalidate()
Date: Sun, 27 Mar 2016 14:16:01 -0400
Message-ID: <20160327181601.GG31129@thunk.org>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
 <1459026600-9232-6-git-send-email-tytso@mit.edu>
 <CA+icZUVtS+Y63LCkk_72EwJqg+BSWSLKo8=W=957Qzwq99S+wQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
	stable@vger.kernel.org
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+icZUVtS+Y63LCkk_72EwJqg+BSWSLKo8=W=957Qzwq99S+wQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Mar 27, 2016 at 10:02:46AM +0200, Sedat Dilek wrote:
> On Sat, Mar 26, 2016 at 10:10 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > This avoids potential problems caused by a race where the inode gets
> > renamed out from its parent directory and the parent directory is
> > deleted while ext4_d_revalidate() is running.
> >
> > Fixes: 28b4c263961c
> 
> Full Fixes-tag...
> 
> Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or
> removing the key")
> 
> > Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: stable@vger.kernel.org
> 
> This for Linux v4.6(-rc1+) ?

Probably v4.6-rc2 at this point, since I'm still waiting for acks from
folks.

						- Ted
