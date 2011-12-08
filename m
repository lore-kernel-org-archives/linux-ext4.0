From: Christian Brunner <chb@muc.de>
Subject: Re: ceph and ext4
Date: Thu, 8 Dec 2011 23:59:29 +0100
Message-ID: <CAO47_-9vGg89HgxjT=dzSSsUxxdbZ=yJoYQk4Qge8WGPjeVmKw@mail.gmail.com>
References: <4EC10664.1080501@tuxadero.com>
	<CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
	<20111115142246.GA7516@thunk.org>
	<246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jian Yu <yujian@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2011/11/15 Andreas Dilger <adilger@whamcloud.com>:
> Coincidentally, we have someone working in those patches again. The main obstacle for accepting the previous patch as-is was that Ted wanted to add support for "medium-sized" xattrs that are addressed as a string of blocks, instead of via an inode.
>
> This will allow xattrs up to 64kB in size (in total) to be stored as efficiently as an external xattr block.
>

Did you make progress with this. I'm still having serious trouble with
btrfs and would like to try these.

Thanks,
Christian
