From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: "make check" broken on maint branch?
Date: Fri, 1 Nov 2013 18:24:09 +0000
Message-ID: <CE98BD77.7C15F%andreas.dilger@intel.com>
References: <20131101032115.GA14263@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20515 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3KASYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Nov 2013 14:24:16 -0400
In-Reply-To: <20131101032115.GA14263@thunk.org>
Content-Language: en-US
Content-ID: <874A209423A8FB4EA7A5B608C76EE1A5@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/10/31 9:21 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:

>On Fri, Nov 01, 2013 at 10:35:56AM +0800, Zheng Liu wrote:
>> Hi Andreas,
>> 
>> On Thu, Oct 31, 2013 at 09:35:25PM +0000, Dilger, Andreas wrote:
>> > I tried to add in a "truncate -s $SIZE_2 $TMPFILE", but it complains
>>that
>> > it isn't able to truncate the file in /tmp to 2TB:
>> > 
>> >   truncating `/tmp/e2fsprogs-tmp.OGxb09' at 2199023255552 bytes: File
>>too
>> > large
>> > 
>> > Testing manually, it seems I'm not allowed to create a file in tmpfs
>>larger
>> > than 256GB.  How large does this file need to be for this test to be
>>valid?
>> > 
>> > Anyone else seen these problems, or do I need to dig in further?
>> 
>> Yes, I also can see these problems.
>
>Hmm.... it works for me.  Run while r_64bit_big_expand is running:
>
>% ls -l tmp
>...
>24896 -rw-r--r--. 1 tytso      tytso      2199023255552 Oct 31 23:17
>e2fsprogs-tmp.pkOcCc
>...
>
>% df /tmp
>Filesystem     1K-blocks  Used Available Use% Mounted on
>tmpfs            3216420 26008   3190412   1% /tmp
>
>What version of the kernel are you running?  I am using 3.12-rc5 plus
>the ext4 dev tree, so I'm using a pretty recent kernel.

It was in the original email - the failing systems are both RHEL6,
2.6.32-358.11.1.el6 (w/4GB RAM) and 2.6.32-279.5.1.el6 (w/ 2GB RAM).
Both fail to create files in tmpfs larger than 256GB.


>Maybe this is a relatively new feature of tmpfs?  If so, I should
>probably change the test so that it's a bit more portable on people
>using older kernels.

Looking at the s_maxbytes value in current kernels shows me that it was
changed in v3.0-7280-g285b2c4 and has not been backported to the RHEL 6
kernel that I'm using at least.


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


