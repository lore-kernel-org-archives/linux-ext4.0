From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] obsolete libcom-err for SuSE e2fsprogs
Date: Mon, 24 Sep 2007 11:25:39 +0200
Message-ID: <20070924092539.GC2819@petra.dvoda.cz>
References: <20070919061404.GA1628@schatzie.adilger.int> <46F1CFC0.3070801@redhat.com> <20070920050923.GX32520@schatzie.adilger.int> <46F2D678.4060203@redhat.com> <20070920215427.GL30221@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4@vger.kernel.org,
	List util-linux-ng <util-linux-ng@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXIXJZv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Sep 2007 05:25:51 -0400
Content-Disposition: inline
In-Reply-To: <20070920215427.GL30221@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 20, 2007 at 05:54:27PM -0400, Theodore Tso wrote:
> On Thu, Sep 20, 2007 at 03:22:16PM -0500, Eric Sandeen wrote:
> > I'd do this, my rpm-fu is still reasonably strong, though - I'm curious,
> > is there a compelling reason to split out just libcom-err?  what about
> > libuuid?  libblkid?  e2fsprogs is a bit of a grab bag of things.  What's
> > the rationale for the split?
> 
> Nope, there isn't much rationale unless we also split out fsck, so

 util-linux-ng is open for fsck :-)

 Seriously, when we move fsck(8) to util-linux-ng we can compile this
 util against libblkid **or** libvolume_id (udev). For example Suse prefers
 libvolume_id, but RHEL/Fedora prefers libblkid, ..etc. The util-linux-ng
 already has fsprobe API for both libraries -- port fsck(8) to
 this API is 10mins work...

> that people who don't want to use any ext 2/3/4 filesystems don't need
> to install programs like e2fsck, mke2fs, libext2fs.so, etc.

 mount(8) dependences on libblkid (or libvolume_id from udev).

 I think sane downstream distributions are using separate binary
 package(s) (RPM calls it subpackages) for libraries from e2fsprogs.

 My $0.02...

    Karel


PS. my workstation with Fedora 7:

# rpm -q --whatrequires libcom_err.so.2 libuuid.so.1 libblkid.so.1 | sort -u
apr-1.2.8-6
apr-util-1.2.8-7
cryptsetup-luks-1.0.5-4.fc7.1
curl-7.16.2-1.fc7
e2fsprogs-libs-1.40.2-2.fc7
evolution-data-server-1.10.3.1-2.fc7
gnome-vfs2-2.18.1-4.fc7
krb5-devel-1.6.1-4.fc7
krb5-libs-1.6.1-4.fc7
libpurple-2.1.1-1.fc7
neon-0.25.5-6
openssl-0.9.8b-14.fc7
pam_krb5-2.2.11-1
parted-1.8.6-4.fc7
subversion-1.4.3-4

-- 
 Karel Zak  <kzak@redhat.com>
