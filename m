From: Theodore Ts'o <tytso@mit.edu>
Subject: Updated version of kvm-xfstests available
Date: Sun, 7 Sep 2014 22:01:01 -0400
Message-ID: <20140908020101.GD1066@thunk.org>
References: <20140809234556.GA11072@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mhalcrow@google.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42821 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaIHCBP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Sep 2014 22:01:15 -0400
Content-Disposition: inline
In-Reply-To: <20140809234556.GA11072@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've uploaded a new set of precompiled kvm-xfstests test appliances
at:

   https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

This new version has an updated xfstests with a few more tests
enabled.  It also features the ability for you to telnet to localhost
ports 7500, 7501, and 7502 and get shell prompts while the tests are
running (if you want to check on /proc/slabinfo, enable tracing, etc.)
You can also access the qemu monitor on port 7498, and you debug the
kernel using remote gdb on localhost port 7499.  Just run "gdb
/path/to/vmlinux", and then use the command "target remote
localhost:7499".  (Pro tip: it's helpful to temporarily add
"EXTRA_CFLAGS += -O0" to fs/{ext4,jbd2}/Makefile, and to make sure you
have CONFIG_DEBUG_INFO, CONFIG_DEBUG_INFO_DWARF4, and
CONFIG_FRAME_POINTER enabled.)

There are a few more options which kvm-xfstests supports, so you can
configure the number of cpus, add additional mount options, etc.
There is also an improved help message, which should explain all of
this and make it much more user-friendly: "./kvm-xfstests help"

Finally, I've added support to help run tests on Michael Halcrow's
encryption patches.  To run it, make sure you have the unstable branch
of the ext4.git tree, which includes some fixes since the last version
he posted, and support for the dummy_encryption mount option.  Then
run the command "./kvm-xfstests -c encrypt -m nodelalloc -g auto".


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

P.S.  If you want to run tests by hand, perhaps because you want to
set up a debug environment do some ftrace setups first, run
"./kvm-xfstests shell", then in the guest shell prompt, run the
command ". test-env".  Then override the environment variables
FSTESTCFG and FSTESTSET (for example: FSTESTCFG=data_journal;
FSTESTSET="ext4/001 generic/013" or FSTESTSET="-g quick"), and then
run the shell script "./runtests.sh"
