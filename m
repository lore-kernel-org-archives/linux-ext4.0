From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC 3/3] systemd integration scripts
Date: Fri, 21 Jul 2017 17:33:10 -0700
Message-ID: <20170722003310.GG4211@magnolia>
References: <20170722002643.GD4211@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50899 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754648AbdGVAdR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jul 2017 20:33:17 -0400
Content-Disposition: inline
In-Reply-To: <20170722002643.GD4211@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's the systemd stuff.  I haven't bothered to supply a cronjob,
since it's trivial to create a cron.weekly entry that runs
/sbin/online-fsck-all.

--D

/lib/systemd/system/online-fsck-all.service:

[Unit]
Description=Scrub Filesystem Metadata
ConditionACPower=true
 
[Service]
Type=oneshot
Environment=SERVICE_MODE=1
ExecStart=/sbin/online-fsck-all

/lib/systemd/system/online-fsck-all.timer:

[Unit]
Description=Scrub Filesystem Metadata Periodically

[Timer]
# Run on Sunday at 3:30am, to avoid running afoul of DST changes
OnCalendar=Sun *-*-* 03:30:00
RandomizedDelaySec=60
Persistent=true

[Install]
WantedBy=timers.target

/lib/systemd/system/online-fsck-fail@.service:

[Unit]
Description=Scrub Filesystem Metadata Failure Reporting for %I

[Service]
Type=oneshot
Environment=EMAIL_ADDR=root@localhost
ExecStart=/usr/lib/online-fsck/online-scrub-fail "${EMAIL_ADDR}" %I
User=mail
Group=mail
SupplementaryGroups=systemd-journal

/lib/systemd/system/online-fsck@.service:

[Unit]
Description=Scrub Filesystem Metadata for %I
OnFailure=online-fsck-fail@%i.service

[Service]
Type=oneshot
WorkingDirectory=/
PrivateNetwork=true
ProtectSystem=true
ProtectHome=read-only
PrivateTmp=yes
AmbientCapabilities=CAP_SYS_ADMIN CAP_SYS_RAWIO
NoNewPrivileges=yes
User=root
IOSchedulingClass=idle
CPUSchedulingPolicy=idle
Environment=SERVICE_MODE=1
ExecStart=/sbin/online-fsck -t %I

/usr/lib/online-fsck/online-scrub-fail:

#!/bin/bash

# Email logs of failed online-fsck unit runs

mailer=/usr/sbin/sendmail
recipient="$1"
test -z "${recipient}" && exit 0
dev="$2"
test -z "${dev}" && exit 0
hostname="$(hostname -f 2>/dev/null)"
test -z "${hostname}" && hostname="${HOSTNAME}"
if [ ! -x "${mailer}" ]; then
	echo "${mailer}: Mailer program not found."
	exit 1
fi

(cat << ENDL
To: $1
From: <online-fsck@${hostname}>
Subject: online-fsck failure on ${dev}

So sorry, the automatic online-fsck of ${dev} on ${hostname} failed.

A log of what happened follows:
ENDL
systemctl status --full --lines 4294967295 "online-fsck@${dev}") | "${mailer}" -t -i
