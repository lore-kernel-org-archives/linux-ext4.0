From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: ceph and ext4
Date: Fri, 9 Dec 2011 15:24:02 -0700
Message-ID: <5D6C7B37-1594-48FF-A682-8CC1FE0A6870@whamcloud.com>
References: <4EC10664.1080501@tuxadero.com> <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com> <20111115142246.GA7516@thunk.org> <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com> <CAO47_-9vGg89HgxjT=dzSSsUxxdbZ=yJoYQk4Qge8WGPjeVmKw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jian Yu <yujian@whamcloud.com>
To: chb@muc.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43354 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1LIWYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2011 17:24:06 -0500
In-Reply-To: <CAO47_-9vGg89HgxjT=dzSSsUxxdbZ=yJoYQk4Qge8WGPjeVmKw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-08, at 3:59 PM, Christian Brunner wrote:
> 2011/11/15 Andreas Dilger <adilger@whamcloud.com>:
>> Coincidentally, we have someone working in those patches again. The main obstacle for accepting the previous patch as-is was that Ted wanted to add support for "medium-sized" xattrs that are addressed as a string of blocks, instead of via an inode.
> 
> Did you make progress with this. I'm still having serious trouble with
> btrfs and would like to try these.

The latest patches are available at http://review.whamcloud.com/1708, but are based on the RHEL6.1 2.6.32 kernel.  The work to implement "medium-sized" xattrs was more complex than anticipated, and is not finished yet.

The use of external inode xattrs is working, which allows xattr sizes up to 64kB.  The 64kB limit is imposed by the VFS and could potentially be increased.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



