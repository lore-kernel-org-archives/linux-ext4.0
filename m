From: Mingming Cao <cmm@us.ibm.com>
Subject: Updated ext4 patches for 2.6.18-rc6
Date: Fri, 08 Sep 2006 00:01:08 -0700
Message-ID: <1157698868.8616.20.camel@localhost.localdomain>
References: <20060908131144sho@rifu.tnes.nec.co.jp>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:2272 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751823AbWIHHBK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Sep 2006 03:01:10 -0400
To: akpm@osdl.org, shaggy@us.ibm.com
In-Reply-To: <20060908131144sho@rifu.tnes.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

Just give you all an update about the latest ext4 patches before I leave
for vacation: The latest ext4 patches (clone ext4 + 48bit ext4) is
against 2.6.18-rc6, as usual, could be found at:

http://ext2.sourceforge.net/ext4/patches/latest/

Haven't done series testing yet, but fsx test runs fine a few hours on
ext4dev filesystem mounted with extents:)

change log since last release (2.6.18-rc4)

rebase ext4/jbd2 clone patches to 2.6.18-rc6 (Mingming Cao<cmm@us.ibm.com>)
rename ext3dev to ext4dev (Randy  Dunlap <rdunlap@xenotime.net>, Mingming Cao <cmm@us.ibm.com)
register-ext4dev.patch
+register-jbd2.patch

*comment fixs in extent patch (Randy  Dunlap <rdunlap@xenotime.net>)
+extents_comment_fix.patch

*change some micro and inline functions to c fuctions(Avantika Mathur<mathur@us.ibm.com)
+64bitmetadata_inline_funcs_fix.patch

*change ext4/jbd2 block type from sector_t to unsigned long long. (Mingming Cao<cmm@us.ibm.com>). remove sector_fmt.patch
+ext4_blk_type_from_sector_t_to_ulonglong.patch
+ext4_remove_sector_t_bits_check.patch
+jbd2_blks_type_from_sector_t_to_ull.patch
-sector_fmt.patch

Andrew, you could pull all the patches(in quilt style) from here(a
series of patches)
http://ext2.sourceforge.net/ext4/patches/latest/broken-out/

Shaggy has nicely offered to maintain and forward all these patches from
here while I am out, thanks, Shaggy:)

Thanks,
Mingming

