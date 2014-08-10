From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 08:38:18 +0800
Message-ID: <CAPTn0cC2a1BdtH2Jjp4NoU4apqzrJdxkPK0vf0Ahq=gds0wj3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33667 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaHJAiT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2014 20:38:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> There is a very big and fundamental difference about project id's
> versus user/group id's, and that is that project id's are not first
> class objects in the file system.  That is, stat() doesn't understand
> them.  Processes do not belong to one (or more) projects, the way they
> do for user and group id's.
Yeah, I totally agree that project ID is different from UID/GID in this
sense. And I think it happens to be why we need project quota rather than
using existing group quota actually.
>
> As a result, project id's are a massive administration nightmare.  You
> can't easily see which project a file belongs to, since "ls" and
> "stat" has no support for the project id.  So if a file is created in
> one directory, the file will inherent that project id from its parent
> directory.  Suppose that file is 100 gigabytes, and it chews up most
> of the project quota for that project.  Now suppose that file is moved
> to some other directory.
>
> How in the world is the administrator supposed to find the file which
> is chewing up 100GB of quota?  Find doesn't support project id's
> either....
That is the same problem when we are scattering inodes with different
UID/GID into directory-trees. I don't think there is any difficulty in
writing a script to locates the files with a specific project ID. It
might be slightly slower than native find, but I don't think there is
any fundamental difference.
>
> The last time I asked why in the world anyone would want to use this
> feature, the only use case that I heard was people who were using
> containers, and where the all of the project id's were inside a
> chroot.  Hence, any questions I asked about what happens when a file
> gets moved out from the hierarchy were hand-waved away, since inside a
> chroot, it could never happen.
I think administrators in HPC or datacenter would like this feature in a
flexible way. I was always getting asked by customers 'how can I know
the spaces/inode used by directoris shared by multiple users/groups'.
'du' doesn't help much because no body wants to wait such a long time if
disk space is at PB-level. In this use case of project quota, I think
it is common for users to move files inside or outside directory-trees.

Regards,
                                       -Li Xi
