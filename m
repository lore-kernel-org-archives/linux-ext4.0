From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC 2/3] scripts to find eligible lv ext4 filesystems
Date: Fri, 21 Jul 2017 17:30:18 -0700
Message-ID: <20170722003018.GF4211@magnolia>
References: <20170722002643.GD4211@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29798 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdGVAa0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jul 2017 20:30:26 -0400
Content-Disposition: inline
In-Reply-To: <20170722002643.GD4211@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

/sbin/online-fsck-all:

#!/bin/bash

types="ext2,ext3,ext4"

# Scrub any fs on lvm by creating a snapshot and fscking that.
lvs --noheadings 2> /dev/null | while read lv vg junk; do
	dev="/dev/${vg}/${lv}"
	blkid -p -n "${types}" "${dev}" > /dev/null 2>&1 || continue

	${DBG} systemctl start "online-fsck@${dev}" 2> /dev/null
	res=$?
	if [ "${res}" -eq 0 ] || [ "${res}" -eq 1 ]; then
		if [ "${res}" -gt 150 ]; then
			res="$((res - 150))"
		fi
		echo "Scrubbing ${dev} done, (err=${res})"
	else
		${DBG} /sbin/online-fsck "${dev}"
	fi
done

# Stupid journald bug where the process still has to exist for
# the last few messages to get tagged to the service...
test -n "${SERVICE_MODE}" && sleep 2

exit 0
