From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] New: ext4 timestamp range contains 68-year gaps
Date: Thu, 25 Nov 2010 11:28:48 GMT
Message-ID: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:38514 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab0KYL2t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 06:28:49 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAPBSmbE009092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 11:28:48 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

           Summary: ext4 timestamp range contains 68-year gaps
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: mh8928@yahoo.com
        Regression: No


When 256-byte inodes are used, ext4 attempts to extend the tv_sec
portion of file timestamps from 32 to 34 bits on 64-bit systems,
presumably to defer the Y2038 problem.  However the code to do
this still fails in 2038.  Nevertheless, some timestamps beyond
the year 2038 work correctly.

Using 2.6.35/x86_64 on ext4 with 256-byte inodes:

markh@zacc:~$ touch -d 2038-01-31 /test/2038
markh@zacc:~$ touch -d 2106-02-22 /test/2106
markh@zacc:~$ ls -l /test/2038 /test/2106
-rw-r--r-- 1 markh markh 0 2038-01-31 00:00 /test/2038
-rw-r--r-- 1 markh markh 0 2106-02-22 00:00 /test/2106
markh@zacc:~$ sudo umount /test
markh@zacc:~$ sudo mount /dev/sda2 /test
markh@zacc:~$ ls -l /test/2038 /test/2106
-rw-r--r-- 1 markh markh 0 1901-12-25 17:31 /test/2038
-rw-r--r-- 1 markh markh 0 2106-02-22 00:00 /test/2106
markh@zacc:~$ 

The problem is in fs/ext4/ext.h.  The macros EXT4_INODE_GET_XTIME
and EXT4_EINODE_GET_XTIME sign-extend the low 32 bits of tv_sec,
and then ext4_decode_extra_time uses "|=" to tack on the 2
additional bits.  However if bit 31 is 1, bits 32..63 will always
be 1 due to the sign extension regardless of the 2 extra bits:

static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
{
       if (sizeof(time->tv_sec) > 4)
           time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
                   << 32;
       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >>
EXT4_EPOCH_BITS;
}

...

#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                   \
do {                                           \
    (inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
    if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
        ext4_decode_extra_time(&(inode)->xtime,                   \
                       raw_inode->xtime ## _extra);           \
} while (0)


It is not clear what time range was intended to be handled,
but the range should be continuous.  Preferably it would be the
range -0x80000000 (1901-12-13) to 0x37fffffff (2446-05-10),
in order to handle all legacy 32-bit timestamps and as many
consecutive future dates as possible.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
