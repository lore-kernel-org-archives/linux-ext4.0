From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 5/5] ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA
Date: Mon, 3 Jul 2017 17:03:54 +0200
Message-ID: <CAHc6FU4rK3cg+nYeOSSJirKoYiuApV9KauqE_iar+7Q7X6g20A@mail.gmail.com>
References: <20170629135420.21357-1-hch@lst.de> <20170629135420.21357-6-hch@lst.de>
 <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com> <20170630173740.GB11420@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170630173740.GB11420@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 30, 2017 at 7:37 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 30, 2017 at 01:51:10PM +0200, Andreas Gruenbacher wrote:
>> Also, ext4 no longer calls inode_lock or inode_lock_shared; that needs
>> to be added back for consistency between reading i_size and walking
>> the file extents.
>
> At least for XFS we never had such a consistency as we never took
> the iolock (aka i_rwsem).

What else does this piece of code from mainline xfs_seek_hole_data()
do instead then?

        lock = xfs_ilock_data_map_shared(ip);

        end = i_size_read(inode);
        offset = __xfs_seek_hole_data(inode, start, end, whence);

Thanks,
Andreas
