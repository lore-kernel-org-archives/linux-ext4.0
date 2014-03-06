From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: an issue of ext4
Date: Thu, 6 Mar 2014 23:57:15 +0000
Message-ID: <CF3CDE77.96870%andreas.dilger@intel.com>
References: <CF3D3A3F.283D%hongchao.zhang@intel.com>
 <20140305125105.GA11600@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	"Zhang, Hongchao" <hongchao.zhang@intel.com>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaCFX5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 18:57:16 -0500
In-Reply-To: <20140305125105.GA11600@thunk.org>
Content-Language: en-US
Content-ID: <36E9521C5C4E514FAC3A54EB6439AC7E@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2014/03/05, 5:51 AM, "Theodore Ts'o" <tytso@mit.edu> wrote:

>On Wed, Mar 05, 2014 at 12:33:32PM +0000, Zhang, Hongchao wrote:
>> 
>> in ext4_fill_super, the variables related to statfs should be
>> initialized after journal recovery is completed.  otherwise, if a
>> large number of blocks were being allocated before the filesystem
>> crashed, then the blocks and inode counters may become negative
>> during use and report incorrect values to statfs call.
>
>The ext4_statfs() doesn't use the free blocks and inodes count from
>the superblock.  For scalability reasons, we no longer update the
>journal values in the superblock while they are in use, but rather
>compute them from the sum of the values from the blockgroup
>descriptors, and then track them via percpu counters.

Ted,
This doesn't relate to using the summary counters in the superblock.

The problem is that the percpu counters are initialized from the
group descriptors (or block and inode bitmaps if EXT4_DEBUG is on)
at mount time _before_ the journal has been replayed.  That means
journal replay can still change the group descriptors (or bitmaps)
after the counters are initialized, and statfs(), allocators, etc.
will use the wrong values for the rest of the mount.

If the journal is large, and there is heavy allocation happening
before the reboot then the counters can be significantly incorrect.

However, looking more closely at the upstream kernel, I see that this
code was changed by Dmitry Monakhov in v2.6.34-rc7-16-g84061e0 to
move the counters after journal init (almost the same as Hongchao's
patch does) but then you submitted a patch v2.6.37-rc1-3-gce7e010
to initialize the percpu counters are both before and after the
journal is loaded.  It isn't clear from your commit comment why
the patch to load them both before and after was needed?

It seems we hit this problem in the RHEL6 (which is missing both of
these changes), and your patch made upstream look like the original
unpatched code was loading the counters only before the journal is
replayed, so Hongchao's patch still applied to upstream.

So I guess upstream is OK, with the exception that it isn't clear
why commit ce7e010 was made.  Need to ask Eric to backport 84061e0
and ce7e010 to RHEL6 I guess, and use those patches in place of
our own in the meantime.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


