From: Chris Hunter <chris.hunter@yale.edu>
Subject: Re: errors following ext3 to ext4 conversion
Date: Thu, 27 Aug 2015 15:28:12 -0400
Message-ID: <55DF64CC.8060201@yale.edu>
References: <55DE5F79.4010004@yale.edu> <20150827033949.GA12151@thunk.org>
 <55DE8771.9050109@redhat.com> <20150827041536.GH10037@birch.djwong.org>
 <20150827185845.GB3357@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vm-emlprdomg-04.its.yale.edu ([130.132.50.162]:56076 "EHLO
	vm-emlprdomg-04.its.yale.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbbH0T2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2015 15:28:15 -0400
In-Reply-To: <20150827185845.GB3357@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
Thanks for the response. As Theodore pointed out, the filesystem already 
had extents. I ran the tune2fs command on a filesystem that had 
previously been converted from ext3 to ext4. I undid features (via 
tune2fs -O ^<flag>) but the read-only fsck errors persist.

Can you elaborate on the risky tune2fs options. I assume you mean 
changes that can't be undone ? or  unsafe ?

regards,
chris hunter
chris.hunter@yale.edu

On 08/27/2015 02:58 PM, Theodore Ts'o wrote:
> On Wed, Aug 26, 2015 at 09:15:36PM -0700, Darrick J. Wong wrote:
>>
>> tune2fs is not as strict as resize2fs; iirc resize whines if it finds ERROR
>> status, lack of VALID status, or it having been too long since the last fsck,
>> whereas tune2fs only cares that the fs is marked VALID.
>>
>> (Scary, if you think about it...)
>
> Originally tune2fs was for things like changing the number of reserved
> blocks in the superblock, or setting a label, etc.  Things for which
> subtle file system corruptions wouldn't be that big of a deal.
>
> Even for setting feature flags, tune2fs doesn't make any fundamental
> changes to the file system other than flipping a few bits.  So for
> Chris, the good news is that undoing the tune2fs changes is relatively
> easy if all he's done since then is to run a read-only e2fsck -n run.
> We just have to flip a few bits.  (Note, the reason why I didn't
> include ^dir_index is that most ext3 file systems created using
> non-paleolithic versions of e2fsprogs will have dir_index turned on
> already.)
>
> But now that we have some tune2fs operations that do resize2fs-like
> operations, we probably should add checks for those more risky
> operations.  And even though feature-flags flipping isn't very scary
> in and of itself, requiring maybe we should require it for that case
> --- although we have historically supported adding things like the
> extents flag, or even the journal when converting from ext2 to ext3,
> while the file system was mounted.
>
> I suspect that would fill Eric's heart with horror, but the ability to
> migrate the root file system from ext2 to ext3 while it was mounted
> (i.e., just run "tune2fs -O has_journal /dev/rootfs" and reboot) was
> something Stephen Tweedie added, so at least at one point Red Hat was
> more adventurous about what it would support in terms of file system
> upgrades without using mkfs.  :-)
>
>      	     		       	       - Ted
>
