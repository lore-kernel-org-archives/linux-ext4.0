From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: ceph and ext4
Date: Tue, 15 Nov 2011 08:43:25 -0800
Message-ID: <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
References: <4EC10664.1080501@tuxadero.com> <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com> <20111115142246.GA7516@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Christian Brunner <chb@muc.de>,
	Martin Mailand <martin@tuxadero.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jian Yu <yujian@whamcloud.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20111115142246.GA7516@thunk.org>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Coincidentally, we have someone working in those patches again. The main obstacle for accepting the previous patch as-is was that Ted wanted to add support for "medium-sized" xattrs that are addressed as a string of blocks, instead of via an inode. 

This will allow xattrs up to 64kB in size (in total) to be stored as efficiently as an external xattr block. 

Cheers, Andreas

On 2011-11-15, at 6:22, Ted Ts'o <tytso@mit.edu> wrote:

> On Tue, Nov 15, 2011 at 09:29:28AM +0100, Christian Brunner wrote:
>> 
>> I'd love to have a working filesystem for ceph, but the xattr issue
>> with ext4 really scares me. That's why I'm still wrestling with btrfs.
> 
> FYI, there are patches to extend ext4 to store xattr's in a separate
> inode.  They were submitted by the Whamcloud (formerly Oracle, Sun,
> Clustrefs -- the Lustre folks).
> 
> Unfortunately I haven't had the personal time and review bandwidth to
> go over the patches, and they haven't been rebased in a while.  I'm
> not opposed to them; they just need some time and loving attention
> from folks with ext4 expertise to accelerate the process of getting
> the patches reviewed, and in mainline.
> 
>                    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
