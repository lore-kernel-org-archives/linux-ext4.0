From: Brad Figg <brad.figg@canonical.com>
Subject: Re: Ubuntu Ext4 regression testing
Date: Wed, 12 Sep 2012 19:50:48 -0700
Message-ID: <50514A08.80903@canonical.com>
References: <50511241.2090603@canonical.com> <20120913021818.GA27544@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2IMCuw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Sep 2012 22:50:52 -0400
In-Reply-To: <20120913021818.GA27544@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/12/2012 07:18 PM, Theodore Ts'o wrote:
> On Wed, Sep 12, 2012 at 03:52:49PM -0700, Brad Figg wrote:
>>
>> The Ubuntu kernel team has been putting some automated testing
>> infrastructure in place. We are very interested in engaging with
>> the appropriate upstream developers. We have been running the
>> xfstests that come as part of the autotest testing framework.
>> Some of these tests fail or never complete when run against an
>> Ext4 file-system.
> 
> Looking at your web page, it looks like xfstests is passing w/o any
> problems for the set of tests that you are running with the 3.5 and
> 3.2 kernels.
> 
> The failures that you are seeing with 3.0 kernel looks funny; it looks
> like you are running the tests one at a time, and after the file
> system got corrupted with the fsstress run with test #13, your test
> framework isn't repairing the file system with e2fsck -fy, so all of
> the tests afterwards failed because the file system was corrupted.  As
> to why the test failed with 3.0, it's probably some problem we didn't
> get backported to 3.0 for some reason.  Quite frankly that's not
> something I really worry about --- as far as I'm concerned, if it
> can't be trivially backported as part of the stable@kernel.org
> process, or after the stable coverage is finished, it's the distro's
> responsibility to backport patches to their
> old/antique/stable/enterprise/LTS kernels --- it's why the
> distributions get paid the big bucks.  :-)
> 
> Also, I noted that some of your failures on the older distributions
> was due to missing userspace programs that were not installed on the
> System Under Test (for example, "chacl").
> 
> 
> As far as how I do my testing, I generally use "./check -g quick" or
> "./check -g auto" --- where "-g auto" takes a lot longer, and there
> are some known failure depending on specific set of mount options and
> how the file system is created.
> 
> Here is my baseline that I had at the start of the 3.6 development
> cycle.  (There are some test failures that are on my todo list to
> investigate more closely, but I keep a baseline to make sure things
> don't regress.)
> 
> I have a script which handles doing all of this automatically using
> KVM, with a single command I can run which takes a built kernel, runs
> it using KVM, and passes the configuration options via the boot
> command-line to a set of shell scripts run out of /etc/rc.local which
> then runs xfstests in the various file system configurations.
> 
> 							- Ted
> 
> 
> BEGIN TEST: Ext4 4k block Sat Jul 28 16:04:48 EDT 2012
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245 246 247 248 249 255 256 257 258 263 271 277
> Passed all 67 tests
> END TEST: Ext4 4k block Sat Jul 28 16:33:53 EDT 2012
> 
> # This is a good way to test using ext4 for ext3 file systems
> BEGIN TEST: Ext4 4k block w/nodelalloc and no extents Sat Jul 28 16:34:03 EDT 2012
> MKFS_OPTIONS  -- -q -O ^extents,^flex_bg,^uninit_bg /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,nodelalloc /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 215 219 221 225 230 235 236 237 240 245 246 247 248 249 257 258 263 271 277
> Passed all 60 tests
> END TEST: Ext4 4k block w/nodelalloc and no extents Sat Jul 28 16:55:23 EDT 2012
> 
> # We care about this in Google, which is why I run it
> BEGIN TEST: Ext4 4k block w/ no journal Sat Jul 28 16:55:26 EDT 2012
> MKFS_OPTIONS  -- -q -O ^has_journal /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,noload /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245 246 247 248 249 255 256 257 258 263 271 277
> Passed all 67 tests
> END TEST: Ext4 4k block w/ no journal Sat Jul 28 17:15:07 EDT 2012
> 
> # This is useful for testing page size != block size --- a big deal with
> # architectures that have 16k pages, such as Power PC or Itanium with a
> # 4k block --- we test for it using x86 and 1k blocks / 4k pages.
> BEGIN TEST: Ext4 1k block Sat Jul 28 17:15:16 EDT 2012
> MKFS_OPTIONS  -- -q -b 1024 /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245 246 247 248 249 255 256 257 258 263 271 277
> Failures: 020
> END TEST: Ext4 1k block Sat Jul 28 18:18:25 EDT 2012
> 
> # Useful for PCIe attached flash devices
> BEGIN TEST: Ext4 4k block w/dioread_nolock Sat Jul 28 18:38:55 EDT 2012
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,dioread_nolock /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245 246 247 248 249 255 256 257 258 263 271 277
> Failures: 091 263
> END TEST: Ext4 4k block w/dioread_nolock Sat Jul 28 19:07:38 EDT 2012
> 
> BEGIN TEST: Ext4 4k block w/data=journal Sat Jul 28 19:07:45 EDT 2012
> MKFS_OPTIONS  -- -q /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity,data=journal /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245 246 247 248 249 255 256 257 258 263 271 277
> Failures: 223
> END TEST: Ext4 4k block w/data=journal Sat Jul 28 19:33:26 EDT 2012
> 
> BEGIN TEST: Ext4 4k block w/bigalloc Sat Jul 28 19:33:35 EDT 2012
> MKFS_OPTIONS  -- -q -O bigalloc /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
> Ran: 001 002 005 006 007 011 013 014 015 020 053 062 069 070 075 076 079 088 091 105 112 113 117 120 123 124 126 128 129 130 131 135 141 169 184 193 198 207 210 211 212 213 214 215 219 221 223 225 228 230 235 236 237 240 243 245 246 247 248 249 257 258 263 271 277
> Failures: 015 219 235
> END TEST: Ext4 4k block w/bigalloc Sat Jul 28 19:52:41 EDT 2012
> 

Thanks, this is very helpful. I wouldn't mind seeing your script if you
feel like sharing it.

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
