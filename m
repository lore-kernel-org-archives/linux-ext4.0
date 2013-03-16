From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Sat, 16 Mar 2013 23:09:23 +0800
Message-ID: <20130316150923.GA18589@gmail.com>
References: <20130315222818.GA16100@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33476 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab3CPOyE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Mar 2013 10:54:04 -0400
Received: by mail-pb0-f53.google.com with SMTP id un1so5019056pbc.26
        for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2013 07:54:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130315222818.GA16100@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 15, 2013 at 06:28:18PM -0400, Eric Whitney wrote:
> I'm seeing Xfstest 285 consistently fail for the 1k test case using the
> latest dev branch while running on both x86 and ARM.  Subtest 08 is
> the problem. From the test output:
> 
> 08. Test file with unwritten extents, only have unwritten pages
> 08.01 SEEK_HOLE expected 0 or 4194304, got 11264.                 FAIL
> 08.02 SEEK_HOLE expected 1 or 4194304, got 11264.                 FAIL
> 08.03 SEEK_DATA expected 10240 or 10240, got 0.                   FAIL
> 08.04 SEEK_DATA expected 10240 or 10240, got 1.                   FAIL
> 
> From previous discussions, we expect 285 to fail in the ext3 (nodelalloc,
> no flex_bg, and no extents) test case, but in subtest 07.  It still does
> that.
> 
> In the dev branch, reverting 4f42f80a8f - "ext4: use s_extent_max_zeroout_kb
> value as number of kb" - results in success for 285 in the 1k test case.

Hi Eric,

I see what's going on.  First of all it isn't a bug. :-)  Please let me
describe why it happens.

In this commit (4f42f80a8f), it tries to fix a bug that we never zero
out an unwritten extent.  So after applied it, when an unwritten extent
is converted, it could be zeroed out.  In xfstests #285 subtest 08 it
preallocates an unwritten extent which is 4MB.  Then it writes some data
at offset 10 * blocksize, which the length is one blocksize, and calles
sync_file_range(2) to flush it.  So the call trace looks like:

ext4_fallocate()
  ->ext4_map_blocks()
    [one unwritten extent is allocated]
ext4_file_write()
ext4_da_writepages()
  ->ext4_map_blocks() with EXT4_GET_BLOCKS_CREATE flag
    ->ext4_ext_handle_uninitialized_extents()
      ->ext4_ext_convert_to_initialized()

In ext4_ext_convert_to_initialized() it tries to zero out unwritten
extent if condition is matched.  Let's see what happens.

case a) 1k block size
  max_zeroout: 32
  ee_len: 4096
  allocated: 4086
  m_len: 1

In this case, the following condition is matched.

fs/ext4/extents.c:3310

        else if (map->m_lblk - ee_block + map-m_len < max_zeroout)
                 10          - 0        + 1         < 32

So unwritten extent [0,11] will be converted to written.  That is why
11264 (11 * 1k) is returned when we seek a hole from offset 0 and 1,
and 0 and 1 are returned when we seek a data from offset 0 and 1.

case b) 4k block size
  max_zeroout: 8
  ee_len: 1024
  allocated: 1014
  m_len: 1

In this case, the above condition won't be matched.

        else if (map->m_lblk - ee_block + map-m_len < max_zeroout)
                 10          - 0        + 1         < 8

So only one unwritten extent [10, 1] is converted, and the test can
pass.

Regards
                                                - Zheng
