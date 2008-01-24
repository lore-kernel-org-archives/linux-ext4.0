From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Thu, 24 Jan 2008 15:27:16 -0600
Message-ID: <479902B4.1050806@redhat.com>
References: <20080124211728.GA24900@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mkoenig@suse.de, hvogel@suse.de,
	Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbYAXV1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2008 16:27:41 -0500
In-Reply-To: <20080124211728.GA24900@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

> Eric, I haven't looked at the FC8/9 e2fsprogs yet, but do they also have
> a ton of patches (possibly in the -pu branch), or do they track upstream
> more closely?

I try to track upstream as closely as I can; F8 had quite a lot of
patches for a while, and I got it whittled down to just a couple.  I
think I'm back up to 7 though :)

Patch1: e2fsprogs-1.39-blkid-devmapper.patch
Patch2: e2fsprogs-1.38-etcblkid.patch
Patch3: e2fsprogs-1.39-mkinstalldirs.patch
Patch4: e2fsprogs-1.40.4-uuidd-tidy.patch
Patch5: e2fsprogs-1.40.4-sb_feature_check_ignore.patch
Patch6: e2fsprogs-1.40.4-blkid-ext4dev.patch
Patch7: e2fsprogs-1.40.4-no-static-e2fsck.patch

...

# look at device mapper devices -
# autoconf-foo to find ldevmapper in /lib
%patch1 -p1 -b .dm
# put blkid.tab in /etc/blkid/ - fedora-ism I think
%patch2 -p1 -b .etcblkid
# Fix for newer autoconf (#220715) - only 'cause we must
# re-run autoconf due to patch 1 IIRC
%patch3 -p1 -b .mkinstalldirs
# uuidd manpage tidyup <--- sent upstream already
%patch4 -p1 -b .uuidd-tidy
# ignore some flag differences on primary/backup sb feature checks
# sent (bad... ) patch upstream, will resend
# ignores flags set on the fly by the kernel
%patch5 -p1 -b .featurecheck
# teach blkid about ext4dev, for now
%patch6 -p1 -b .ext4-blkid
# completely clobber e2fsck.static build,
# fedora is missing some .a's, and don't need it
%patch7 -p1 -b .e2fsck-static




> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
