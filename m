From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] e2fsprogs: Fix write size in ext2fs_mmp_write
Date: Fri, 11 Nov 2011 21:13:09 -0500
Message-ID: <20111112021309.GE4055@thunk.org>
References: <4EBC5524.3000105@redhat.com>
 <4EBC577C.9010607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35109 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab1KLFQI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Nov 2011 00:16:08 -0500
Content-Disposition: inline
In-Reply-To: <4EBC577C.9010607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 10, 2011 at 05:00:12PM -0600, Eric Sandeen wrote:
> Without this change, we will write data past the end of the
> mmp buf.  Valgrind catches this:
> 
> ==6373== Syscall param write(buf) points to unaddressable byte(s)
> ==6373==    at 0x362260E470: __write_nocancel (in /lib64/libpthread-2.12.2.so)
> ==6373==    by 0x41CF83: raw_write_blk (unix_io.c:255)
> ==6373==    by 0x41D2BC: unix_write_blk64 (unix_io.c:757)
> ==6373==    by 0x41A05D: ext2fs_mmp_write (mmp.c:130)
> ==6373==    by 0x40B0C9: do_set_mmp_value (set_fields.c:806)
> ==6373==    by 0x421B61: really_execute_command (execute_cmd.c:108)
> ==6373==    by 0x421C54: ss_execute_line (execute_cmd.c:234)
> ==6373==    by 0x403743: main (debugfs.c:2339)
> ==6373==  Address 0x63f000 is not stack'd, malloc'd or (recently) free'd
> 
> and in my testing it led to silent failures while writing the mmp
> block in debugfs:
> 
> write(3, "xV4\22PMM\342\325V\274N\0\0\0\0host.name."..., 4096) = -1 EFAULT (Bad address)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

						- Ted
