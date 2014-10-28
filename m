From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Updated version of kvm-xfstests available
Date: Tue, 28 Oct 2014 11:20:30 -0400
Message-ID: <20141028152030.GA9530@thunk.org>
References: <20140809234556.GA11072@thunk.org>
 <20140908020101.GD1066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mhalcrow@google.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48624 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaJ1PUd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2014 11:20:33 -0400
Content-Disposition: inline
In-Reply-To: <20140908020101.GD1066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've uploaded a new set of precompiled kvm-xfstests test appliances
at:

   https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

This new version has an updated xfstests with some additional tests
enabled (some of which test bugs that were only fixed in the recent
merge window, so if you are testing older kernels, some of the new
tests may fail).

There aren't that many changes to the framework this time that are
visible to users.  It is now possible to automatically build a local
mirror of the debian packages, and you can also update an existing
root_fs.img without regenerating the base OS image.  Both of these
allow new root_fs images to be built more quickly and without
requiring network access, which is handy for people who are doing
xfstests development.

If you have a local git repository of xfstests-bld, make sure you do a
"git pull" to update the latest version of the kvm-xfstests shell
script.  If you download the root_fs.img file from www.kernel.org, you
won't have build xfstests on your own.  Just drop the root_fs.img file
in kvm-xfstests/test-appliance, look at kvm-xfstests/config and
override various parameters using ~/.config/kvm-xfstests or in the
kvm-xfstests/config.custom file.  When you're ready, cd into the
kvm-xfstests directory, and then run "./kvm-xfstests smoke" and make
sure everything works.

Enjoy, and have fun!!

 						- Ted

P.S.  There is a baseline run of ext4 for 3.18-rc2 available here:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/baseline-3.18-rc2.xz

I'm seeing some oom-kills that affect generic/273 and generic/224 but
the tests do run to completion (which they weren't after 3.18-rc1 +
the ext4 commits for the merge window, or during the last development
cycle).  It may be that the extent status tree shrinker patches will
address the remaining oom-kills.
