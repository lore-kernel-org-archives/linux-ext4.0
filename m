From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH e2fsprogs-1.40.8] logdump : Add the missing option in usage of logdump.
Date: Tue, 1 Apr 2008 09:20:56 +0530
Message-ID: <ea11fea30803312050s79c50a4euc072e027a5300af@mail.gmail.com>
References: <ea11fea30803302122x76ad0a70w5e41dc685fe7e6fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:16618 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbYDADu5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2008 23:50:57 -0400
Received: by ug-out-1314.google.com with SMTP id z38so24612ugc.16
        for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 20:50:56 -0700 (PDT)
In-Reply-To: <ea11fea30803302122x76ad0a70w5e41dc685fe7e6fa@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

 logdump code currently accepts an option "-s" to use journal from the
 superblock backup. However this option is not getting printed in the
 usage which means user will not be aware of this option unless he
 reads the code.

 =========================================================================
 Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

 diff -Naur a/debugfs/logdump.c b/debugfs/logdump.c
 --- a/debugfs/logdump.c 2008-03-14 03:50:46.000000000 +0530
 +++ b/debugfs/logdump.c 2008-03-31 09:51:14.000000000 +0530
 @@ -88,7 +88,7 @@
        struct journal_source journal_source;
        struct ext2_super_block *es = NULL;

 -       journal_source.where = 0;
 +       journal_source.where = JOURNAL_IS_INTERNAL;
        journal_source.fd = 0;
        journal_source.file = 0;
        dump_all = 0;
 @@ -264,7 +264,7 @@
        return;

  print_usage:
 -       fprintf(stderr, "%s: Usage: logdump [-ac] [-b<block>] [-i<inode>]\n\t"
 +       fprintf(stderr, "%s: Usage: logdump [-acs] [-b<block>] [-i<inode>]\n\t"
                "[-f<journal_file>] [output_file]\n", argv[0]);
  }

 ==============================================================================

 --
 Thanks & Regards,
 ********************************************
 Manish Katiyar ( http://mkatiyar.googlepages.com )
 3rd Floor, Fair Winds Block
 EGL Software Park
 Off Intermediate Ring Road
 Bangalore 560071, India
 ***********************************************
