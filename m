From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Sun, 05 Feb 2012 11:23:21 -0600
Message-ID: <4F2EBB09.6080905@redhat.com>
References: <4F2D8F30.3090802@redhat.com> <201202050933.q159XQpB026380@helium.internal.tigress.co.uk> <4F2EB017.5090006@redhat.com> <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ron Yorston <rmy@tigress.co.uk>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab2BERXZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Feb 2012 12:23:25 -0500
In-Reply-To: <9C5B5C07-B0E4-4D13-BCFE-7F35162DF5E8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/5/12 10:55 AM, Andreas Dilger wrote:
> On 2012-02-05, at 9:36, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 2/5/12 3:33 AM, Ron Yorston wrote:
>>> Eric Sandeen wrote:
>>>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>>>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>>>>
>>>> I'll see if util-linux wants it after it gets beat into shape.
>>>> (or did a tool like this already exist and I missed it?)
>>
>> Matthias' suggestion of adding SEEK_HOLE/SEEK_DATA makes very good sense too.
> 
> I thought about this, but if SEEK_HOLE/SEEK_DATA (or FIEMAP) worked,
> then the file would already be sparse, so I don't think that will
> help in this case...

But only if other tools originally used them, and there will probably be plenty
of cases where they don't, or legacy files, or ....

>> I should also untie the read/zero buffer size from the minimum hole size,
>> we should do optimal IO sizes regardless of the minimum hole size desired...
> 
> Definitely. 4kB IO is a killer for large files.

yeah, it was a quick hack, I'll try to fix that up.

(OTOH for large files you man not want a 4k hole granularity either)

-Eric

> Cheers, Andreas

