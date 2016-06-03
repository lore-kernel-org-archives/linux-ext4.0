From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: xfstests generic/130 hang with non-4k block size ext4 on 4.7-rc1
 kernel
Date: Fri, 3 Jun 2016 18:16:12 +0800
Message-ID: <20160603101612.GJ10350@eguan.usersys.redhat.com>
References: <20160531140922.GM5140@eguan.usersys.redhat.com>
 <20160531154017.GC5357@thunk.org>
 <20160601063822.GH10350@eguan.usersys.redhat.com>
 <20160601165800.GI10350@eguan.usersys.redhat.com>
 <20160602085840.GH19636@quack2.suse.cz>
 <20160602121750.GC32574@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eryu Guan <eguan@redhat.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36387 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbcFCKQU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2016 06:16:20 -0400
Received: by mail-pf0-f181.google.com with SMTP id f144so42418371pfa.3
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jun 2016 03:16:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160602121750.GC32574@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2016 at 02:17:50PM +0200, Jan Kara wrote:
> 
> So I was trying but I could not reproduce the hang either. Can you find out
> which page is jbd2 thread waiting for and dump page->index, page->flags and
> also bh->b_state, bh->b_blocknr of all 4 buffer heads attached to it via
> page->private? Maybe that will shed some light...

I'm using crash on live system when the hang happens, so I got the page
address from "bt -f"

 #6 [ffff880212343b40] wait_on_page_bit at ffffffff8119009e
    ffff880212343b48: ffffea0002c23600 000000000000000d 
    ffff880212343b58: 0000000000000000 0000000000000000 
    ffff880212343b68: ffff880213251480 ffffffff810cd000 
    ffff880212343b78: ffff88021ff27218 ffff88021ff27218 
    ffff880212343b88: 00000000c1b4a75a ffff880212343c68 
    ffff880212343b98: ffffffff811901bf

The call is "wait_on_page_bit(page, PG_writeback);" and PG_writeback is
13 of type enum, which is 0xd in hex. So ffffea0002c23600 might be the
page address. (Confirmed by following the page to the correct inode)

So page->index:
 crash> page ffffea0002c23600 | grep index
      index = 2441406,

page->flags:
 crash> page ffffea0002c23600 | grep flags
   flags = 9007197107267616,
 crash> eval 9007197107267616
 hexadecimal: 1fffff80002820  
     decimal: 9007197107267616  
       octal: 377777760000024040
      binary: 0000000000011111111111111111111110000000000000000010100000100000

page->private:
 crash> page ffffea0002c23600 | grep private
     private = 18446612141237651696, 
 crash> eval 18446612141237651696
 hexadecimal: ffff880213e0c8f0

The 4 buffer heads:
crash> buffer_head ffff880213e0c8f0
struct buffer_head {
  b_state = 0, 
  b_this_page = 0xffff880213e0c958, 
  b_page = 0xffffea0002c23600, 
  b_blocknr = 18446744073709551615, 
  b_size = 1024, 
  b_data = 0xffff8800b08d8000 "", 
  b_bdev = 0x0, 
  b_end_io = 0x0, 
  b_private = 0x0, 
  b_assoc_buffers = {
    next = 0xffff880213e0c938, 
    prev = 0xffff880213e0c938
  }, 
  b_assoc_map = 0x0, 
  b_count = {
    counter = 0
  }
}
crash> buffer_head 0xffff880213e0c958
struct buffer_head {
  b_state = 289, 
  b_this_page = 0xffff880213e0c9c0, 
  b_page = 0xffffea0002c23600, 
  b_blocknr = 19194, 
  b_size = 1024, 
  b_data = 0xffff8800b08d8400 "a", 
  b_bdev = 0xffff8802152009c0, 
  b_end_io = 0x0, 
  b_private = 0x0, 
  b_assoc_buffers = {
    next = 0xffff880213e0c9a0, 
    prev = 0xffff880213e0c9a0
  }, 
  b_assoc_map = 0x0, 
  b_count = {
    counter = 0
  }
}
crash> buffer_head 0xffff880213e0c9c0
struct buffer_head {
  b_state = 1, 
  b_this_page = 0xffff880213e0ca28, 
  b_page = 0xffffea0002c23600, 
  b_blocknr = 18446744073709551615, 
  b_size = 1024, 
  b_data = 0xffff8800b08d8800 "", 
  b_bdev = 0x0, 
  b_end_io = 0x0, 
  b_private = 0x0, 
  b_assoc_buffers = {
    next = 0xffff880213e0ca08, 
    prev = 0xffff880213e0ca08
  }, 
  b_assoc_map = 0x0, 
  b_count = {
    counter = 0
  }
}
crash> buffer_head 0xffff880213e0ca28
struct buffer_head {
  b_state = 1, 
  b_this_page = 0xffff880213e0c8f0, 
  b_page = 0xffffea0002c23600, 
  b_blocknr = 18446744073709551615, 
  b_size = 1024, 
  b_data = 0xffff8800b08d8c00 "", 
  b_bdev = 0x0, 
  b_end_io = 0x0, 
  b_private = 0x0, 
  b_assoc_buffers = {
    next = 0xffff880213e0ca70, 
    prev = 0xffff880213e0ca70
  }, 
  b_assoc_map = 0x0, 
  b_count = {
    counter = 0
  }
}

If you need anything else please let me know.

And just a follow-up on the testing with different kernel configs, I can
still reproduce the hang easily with OpenSuSE based kernel, and I still
have trouble booting the kernel compiled with Ted's config file... Maybe
it's missing some modules, but there're so many of them, I trend to give
up :)

Thanks,
Eryu
