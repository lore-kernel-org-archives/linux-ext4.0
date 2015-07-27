From: Eric Whitney <enwlinux@gmail.com>
Subject: generic/064 test failures on ext4 (4.2-rc*)
Date: Mon, 27 Jul 2015 15:10:03 -0400
Message-ID: <20150727190957.GA1606@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: a.sangwan@samsung.com, linux-ext4@vger.kernel.org
To: namjae.jeon@samsung.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36837 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbbG0TIx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jul 2015 15:08:53 -0400
Received: by qkdv3 with SMTP id v3so42995246qkd.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2015 12:08:52 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Namjae:

I'm seeing generic/064 fail consistently when testing ext4 on 4.2-rc kernels
with Ted's kvm-xfstests test appliance.

The two kvm-xfstests test cases that fail are ext3conv and data_journal. Both
of them force disablement of delayed allocation.  The nodelalloc mount option
is used explicitly in the ext3conv case, and it's set implicitly in the kernel
when the data_journal mount option is used.  The size of the scratch device
used also matters.  The failure occurs when the device is 5 GB in size, but
does not when 20 GB in size.

What's happening is that when nodelalloc is set, ext4 produces a testfile.dest
containing 101 extents when generic/064 inserts 100 block ranges, and this does
not match the test's expected output of 100 extents.

Ted Ts'o says that ext4 does not guarantee a specific extent layout when
delayed allocation is disabled in these circumstances.

The header comment for generic/064 states that insert range is to be called
until 100 extents are created.  Would the intent of your test be preserved if
it was modified to verify that 100 holes were inserted rather than 100
extents created?  This would seem to be a more direct way to verify that
insert range was functioning correctly without assuming anything about other
test filesystem behavior.  ext4 does create 100 holes for generic/064 with
nodelalloc set.

Thanks,
Eric
