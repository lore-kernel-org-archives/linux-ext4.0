From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: freeze_bdev hangs
Date: Mon, 08 Oct 2012 13:21:36 -0500
Message-ID: <507319B0.8040202@redhat.com>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com> <506F19E6.8030005@redhat.com> <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Prashant Shah <pshah.mumbai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab2JHSVi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 14:21:38 -0400
In-Reply-To: <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/8/12 2:43 AM, Prashant Shah wrote:
> Hi,
> 
> On Fri, Oct 5, 2012 at 11:03 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> I haven't looked at your custom code, but freeze has changed a bit lately,
>> and "hangs" is a very vague description
>>
>> -Eric
> 
> I am monitoring the file system (ext3) for block writes and on
> linux-2.6.18 (centos - 5.8 64bit) there are lots of writes request per
> second with inode number set to 0 even when the file system is idle
> and without any work loads. Didnt see this happen on linux-3.x.
> 
> filter: sector=242983 inode=0

if you dumpe2fs your fs you may find those sectors contain metadata not data.

Anyway, did you try the suggestions I offered to track down your original
question about the freeze deadlock?

-Eric

> filter: sector=242991 inode=0
> filter: sector=242999 inode=0
> filter: sector=243007 inode=0
> filter: sector=243015 inode=0
> filter: sector=243023 inode=0
> filter: sector=243031 inode=0
> filter: sector=243039 inode=0
> 
> What are these request with inode number as 0 ? All the special inode
> numbers start from 1.
> 
> http://lxr.linux.no/#linux+v2.6.32/include/linux/ext3_fs.h#L56
> 
> Regards.
> 

