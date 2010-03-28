From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize: check s_log_groups_per_flex before accessing
 flex groups
Date: Sun, 28 Mar 2010 10:26:50 -0500
Message-ID: <4BAF753A.3070704@redhat.com>
References: <4BAE5D40.5050809@redhat.com> <96C33B08-CDC5-48B3-98C0-479F230E7F98@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alessandro Polverini <alex@nibbles.it>,
	Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab0C1P1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Mar 2010 11:27:03 -0400
In-Reply-To: <96C33B08-CDC5-48B3-98C0-479F230E7F98@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-03-27, at 13:32, Eric Sandeen wrote:
>> #13549, Kernel oops while online resizing of an ext4 filesystem
>>
>> if groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
>> and every other access to this first tests s_log_groups_per_flex;
>> same thing needs to happen in resize or we'll wander off into
>> a null pointer.
> 
> Does it even make sense to set INCOMPAT_FLEX_BG if we only have a single
> group per flexbg?  That is just a normal filesystem then.  That would be
> a separate bug in mke2fs.

yes, I really wondered about that, but we have this check throughout the
ext4 kernel code right now, so as a quick fix ...

(note in this case it was an ext3 fs converted to ext4, with tune2fs:)

# tune2fs -O extents,uninit_bg,dir_index,flex_bg,huge_file,dir_nlink,extra_isize fsfile

I haven't honestly looked at what it means to "turn on" flex_bg
for a filesystem not originally mkfs'd with it.  I'm not sure it does
anything other than setting the flag, leaving flex group size == group size.

Thanks,
-Eric
