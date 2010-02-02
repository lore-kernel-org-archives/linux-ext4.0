From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 07/23] vfs: Add Posix acl to rich acl mapping helpers
Date: Tue, 02 Feb 2010 10:52:53 +0530
Message-ID: <87wryw43f6.fsf@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1265002505-8387-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100201231816.GQ19418@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, jlayton@redhat.com,
	linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-ext4@vger.kernel.org
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56778 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0BBFXG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Feb 2010 00:23:06 -0500
In-Reply-To: <20100201231816.GQ19418@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 1 Feb 2010 18:18:16 -0500, "J. Bruce Fields" <bfields@citi.umich.edu> wrote:
> On Mon, Feb 01, 2010 at 11:04:49AM +0530, Aneesh Kumar K.V wrote:
> > This patch add helpers that can be used by the file system to map
> > posix acls to rich acl format. This enables the file system to
> > return rich acl mapping the posix acls stored on disk when the
> 
> You mean, to return a rich acl which is a mapped version of the posix
> acl stored on disk?

Yes


> 
> > file system is enabled with rich acl format.
> 
> Then I assume if you modified the acl, the filesystem would replace
> the existing posix acl by a "rich acl"?
> 

Yes

> The idea being to allow you to convert an existing posix-acl-using
> filesystem to rich acl's?  (But not the reverse.)
> 

Exactly. 

For ex:

/mnt# touch a
/mnt# getfacl a
# file: a
# owner: root
# group: root
user::rw-
group::r--
other::r--

/mnt# setfacl  -m u:guest:rw a
/mnt# getfacl a
# file: a
# owner: root
# group: root
user::rw-
user:guest:rw-
group::r--
mask::rw-
other::r--

# umount /mnt/
# tune2fs  -O richacl  /dev/vdc
# mount /dev/vdc /mnt  -o acl
# cd /mnt/
/mnt# getfacl  a
# file: a
# acl format: richacl
# owner: root
# group: root
flags:pP                        <----- 'P' indicate Posix mapped
    owner@:---------x-T--M--s::deny
    owner@:-r-w-a-----T--M--s::allow
     guest:---------x-T--M--s::deny
     guest:-r-w-a-----T--M--s::allow
    group@:-r---------T--M--s::allow
    group@:---w-a---x-T--M--s::deny
 everyone@:-r---------T--M--s::allow

/mnt# setrichacl  --modify guest:r::allow a
/mnt# getfacl  a
# file: a
# acl format: richacl
# owner: root
# group: root
flags:p                          <---- Posix mapped flag is dropped
    owner@:---------x-T--M--s::deny
    owner@:-r-w-a------------::allow
     guest:---------x-T--M--s::deny
     guest:-r----------------::allow
    group@:-r---------T--M--s::allow
    group@:---w-a---x-T--M--s::deny
 everyone@:-r---------T--M--s::allow
