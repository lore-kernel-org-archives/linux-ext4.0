From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/6 v2] ext4: Update inode i_size after the
 preallocation
Date: Mon, 17 Mar 2014 11:48:30 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403171148130.30625@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com> <1393355679-11160-2-git-send-email-lczerner@redhat.com> <20140317030201.GE14162@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140317030201.GE14162@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 16 Mar 2014, tytso@mit.edu wrote:

> Date: Sun, 16 Mar 2014 23:02:01 -0400
> From: tytso@mit.edu
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 1/6 v2] ext4: Update inode i_size after the preallocation
> 
> On Tue, Feb 25, 2014 at 08:14:34PM +0100, Lukas Czerner wrote:
> > Currently in ext4_fallocate we would update inode size, c_time and sync
> > the file with every partial allocation which is entirely unnecessary. It
> > is true that if the crash happens in the middle of truncate we might end
> > up with unchanged i size, or c_time which I do not think is really a
> > problem - it does not mean file system corruption in any way. Note that
> > xfs is doing things the same way e.g. update all of the mentioned after
> > the allocation is done.
> > 
> > This commit moves all the updates after the allocation is done. In
> > addition we also need to change m_time as not only inode has been change
> > bot also data regions might have changed (unwritten extents). However
> > m_time will be only updated when i_size changed.
> > 
> > Also we do not need to be paranoid about changing the c_time only if the
> > actual allocation have happened, we can change it even if we try to
> > allocate only to find out that there are already block allocated. It's
> > not really a big deal and it will save us some additional complexity.
> > 
> > Also use ext4_debug, instead of ext4_warning in #ifdef EXT4FS_DEBUG
> > section.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Further testing has shown that this patch (applied on top of the ext4
> dev branch) is causing a regression failure of xfstests shared/243.
> 
> Could you take a look?
> 
> 						- Ted

Hi Ted,

I am looking into this. Thanks!

-Lukas
