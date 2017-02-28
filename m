From: Xiong Zhou <xzhou@redhat.com>
Subject: Ext4 new shutdown ioctl fails generic/04{4,5,6}
Date: Tue, 28 Feb 2017 11:25:56 +0800
Message-ID: <20170228032556.dc5d26cldwku4puw@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On latest Linus tree, xfstests generic/04{4,5,6} fails.

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 rhel73 4.10.0-master-45554b2+
MKFS_OPTIONS  -- /dev/sdc
MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:nfs_t:s0 /dev/sdc /test2

generic/045	 - output mismatch (see /root/xfstests-dev/results//generic/045.out.bad)
    --- tests/generic/045.out	2017-02-21 21:49:05.045000000 -0500
    +++ /root/xfstests-dev/results//generic/045.out.bad	2017-02-27 22:24:52.444000000 -0500
    @@ -1 +1,1000 @@
     QA output created by 045
    +corrupt file /test2/1 - non-zero size but no extents
    +corrupt file /test2/2 - non-zero size but no extents
    +corrupt file /test2/3 - non-zero size but no extents
    +corrupt file /test2/4 - non-zero size but no extents
    +corrupt file /test2/5 - non-zero size but no extents
    +corrupt file /test2/6 - non-zero size but no extents
