From: Eric Sandeen <sandeen@redhat.com>
Subject: blkid oddities with stale devices in the cache
Date: Fri, 20 Jun 2008 23:59:26 -0500
Message-ID: <485C8AAE.5020005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYFUE73 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Jun 2008 00:59:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is w.r.t. https://bugzilla.redhat.com/show_bug.cgi?id=452333

Dave had a few stale entries in blkid.tab; label from a usb key showed
up under several non-existent, stale device names.  fstab had LABEL=,
mounting by label failed because blkid returned a stale, nonexistent device.

It seems there's a problem in blkid_verify():

        if (((probe.fd = open(dev->bid_name, O_RDONLY)) < 0) ||
            (fstat(probe.fd, &st) < 0)) {
                if (probe.fd >= 0) close(probe.fd);
                if ((errno != EPERM) && (errno != EACCES) &&
                    (errno != ENOENT)) {
                        DBG(DEBUG_PROBE,
                            printf("blkid_verify: error %s (%d) while "
                                   "opening %s\n", strerror(errno), errno,
                                   dev->bid_name));
                        blkid_free_dev(dev);
                        return NULL;
                }
                /* We don't have read permission, just return cache data. */
                DBG(DEBUG_PROBE,
                    printf("returning unverified data for %s\n",
                           dev->bid_name));
                return dev;

We find the bad/stale device in the cache, and stat it - if the device
doesn't exist, we get ENOENT.  But we return the stale data for the
nonexistent device anyway.  Eh?

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=commitdiff;h=8bcaaabb1a023af4852dbf0dba76249982c62e40

did this:

When a nonprivileged user uses the blkid command, we want to keep the
cached filesystem information, and opening a device file could result
in an EACCESS or ENOENT (if an intervening directory is mode 700).  We
were previously testing for EPERM, which was really the wrong error
code to be testing against.

But do we really want to do this in the case of ENOENT?  It seems like
this is going to grow a crop of missing devices in the cache, no?

Thanks,

-Eric
