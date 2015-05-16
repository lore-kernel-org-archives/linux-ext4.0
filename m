From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Lazytime undone by/not working with remount?
Date: Sat, 16 May 2015 11:05:04 +0000 (UTC)
Message-ID: <pan.2015.05.16.11.05.04@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58768 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbbEPLFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 07:05:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1YtZu2-0003Zq-T8
	for linux-ext4@vger.kernel.org; Sat, 16 May 2015 13:05:10 +0200
Received: from pd953e5c7.dip0.t-ipconnect.de ([217.83.229.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 16 May 2015 13:05:10 +0200
Received: from holger.hoffstaette by pd953e5c7.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 16 May 2015 13:05:10 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

playing with lazytime on 4.0.4-rc1 + yesterday's fencepost patch) I noticed
something odd. Mounting secondary (non-root) partitions with lazytime works
fine, but / does not seem to retain the value from fstab - apparently because
it is remounted rw during boot, and lazytime gets swallowed/undone.

Same effect when trying to remount manually with lazytime:

tux>findmnt /
TARGET SOURCE    FSTYPE OPTIONS
/      /dev/sda1 ext4   rw,noatime

tux>mount -o lazytime,remount / 

tux>dmesg 
[ 5208.482505] EXT4-fs (sda1): re-mounted. Opts: (null)

tux>findmnt /                  
TARGET SOURCE    FSTYPE OPTIONS
/      /dev/sda1 ext4   rw,noatime

tux>mount --version
mount from util-linux 2.26.2 (libmount 2.26.0: assert, debug)

Newly mounting unmounted partitions works fine.

Any ideas?

Holger

