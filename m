From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: do not disable ext4 discards on first discard failure? [was: Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Thu, 28 Apr 2011 19:12:54 -0600
Message-ID: <1D2A9D06-CBD3-4DC8-B1D5-69DDCEB44238@dilger.ca>
References: <20110412234706.GA11244@redhat.com> <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3289 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1D2BM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Apr 2011 21:12:56 -0400
In-Reply-To: <20110428205935.GA24979@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 28, 2011, at 14:59, Mike Snitzer wrote:
> On Thu, Apr 28 2011 at  3:53am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
>> On Wed, Apr 27, 2011 at 08:19:13PM -0400, Mike Snitzer wrote:
>>> Discards pose a problem for the snapshot-origin target because they are
>>> treated as writes.  Treating a discard as a write would trigger a
>>> copyout to the snapshot.  Such copyout can prove too costly in the face
>>> of otherwise benign scenarios (e.g. create a snapshot and then mkfs.ext4
>>> the origin -- mkfs.ext4 discards the entire volume by default, which
>>> would copyout the entire origin volume to the snapshot).
>> 
>> You also need to make sure that we don't claim discard_zeroes_data for
>> the origin volume in this case.  Especially as ext4 started to rely
>> on this actually working (very bad idea IMHO, but that's another story)
> 
> Eric Sandeen helped me see that having the DM snapshot-origin target
> return success but actually ignore discards is just bad form.
> 
> Especially when you consider that this exercise was motivated by the
> fact that ext4 will disable discards on the first discard failure, see:
> http://www.redhat.com/archives/dm-devel/2011-April/msg00070.html
> 
> Eric and I think it is best to revert this commit:
> a30eec2 ext4: stop issuing discards if not supported by device
> 
> (though ideally ext4 would still WARN_ONCE per superblock with something
> like: "discard failed, please consider disabling discard support")
> 
> 1) The user asked for discards (with '-o discard' mount option)
>   - what is the real harm in coninuing to issue them even if it _seems_
>     they aren't supported?

Aren't discard operations considered barriers?  If there are needless discard operations being sent to the disk then it seems like this would have a non-zero performance penalty, just by virtue of blocking IO submissions at the block device layer.

If my understanding of the mechanics is flawed, then please ignore.

> 2) assuming the entire block device uniformly supports discards can
>   be flawed (a DM device's discard support can vary based on logical
>   offset).

Hybrid storage is potentially an increasingly popular configuration.  We've been looking at DM-mapped SSD RAID-1 + HDD RAID-6 arrays for ext4 to allow storing only the metadata on SSD.  That said, it may make sense to have the DM translation layer check the component devices of an LV to see if discard is supported on any of them, and only return -EOPNOTSUPP if none of them do.

While not a perfect solution for the case where an LV is migrated onto a device that does support discard, I don't think we have to handle every corner case perfectly to still handle reasonable use cases in a sensible manner.

Cheers, Andreas





