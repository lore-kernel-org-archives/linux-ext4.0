From: Karel Zak <kzak@redhat.com>
Subject: Re: uti-linux-ng libblkid
Date: Wed, 18 Mar 2009 20:28:01 +0100
Message-ID: <20090318192801.GB16333@nb.net.home>
References: <1235410733-4193-1-git-send-email-kzak@redhat.com> <20090309010833.GE5578@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58113 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZCRT2W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 15:28:22 -0400
Content-Disposition: inline
In-Reply-To: <20090309010833.GE5578@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 08, 2009 at 09:08:33PM -0400, Theodore Tso wrote:
> On Mon, Feb 23, 2009 at 06:38:51PM +0100, Karel Zak wrote:
> > here are two patches that allow to link utils from e2fsprogs with
> > external libblkid (e.g. the version from util-linux-ng).
> 
> Thanks, I'm starting to play with the builtin fsprobe libraries in
> util-linux-ng right now.  Some quick issues I've found right off the
> bat.  Automake is returning these errors:

 Ted, use 
   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.15/util-linux-ng-2.15-rc1.tar.bz2
 
 I look forward to see the patches in e2fsprogs ;-)

 I have question, do you think that you can freeze the libblkid
 version number in e2fsprogs? (now it's <maj>.<min>.<rel> = 1.41.4) 
 
 I think it makes sense to increment the major and minor version
 numbers in util-linux-ng only. The version in e2fsprogs should be in
 feature-freeze state.

 The current libblkid version number in util-linux-ng-2.15-rc1 is 
 1.99.0 -- but I'd like to use something more sane for the final
 release.

 Thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
