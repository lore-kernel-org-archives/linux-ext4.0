From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: do not disable ext4 discards on first discard failure? [was:
 Re: dm snapshot: ignore discards issued to the snapshot-origin target]
Date: Fri, 29 Apr 2011 11:30:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
References: <20110412234706.GA11244@redhat.com> <20cf301cbef67d323104a0c2ff52@google.com> <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org>
 <20110428205935.GA24979@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab1D2JbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Apr 2011 05:31:05 -0400
In-Reply-To: <20110428205935.GA24979@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 28 Apr 2011, Mike Snitzer wrote:

> [cc'ing linux-ext4]
> 
> On Thu, Apr 28 2011 at  3:53am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Wed, Apr 27, 2011 at 08:19:13PM -0400, Mike Snitzer wrote:
> > > Discards pose a problem for the snapshot-origin target because they are
> > > treated as writes.  Treating a discard as a write would trigger a
> > > copyout to the snapshot.  Such copyout can prove too costly in the face
> > > of otherwise benign scenarios (e.g. create a snapshot and then mkfs.ext4
> > > the origin -- mkfs.ext4 discards the entire volume by default, which
> > > would copyout the entire origin volume to the snapshot).
> > 
> > You also need to make sure that we don't claim discard_zeroes_data for
> > the origin volume in this case.  Especially as ext4 started to rely
> > on this actually working (very bad idea IMHO, but that's another story)

I do not think that it is bad idea. It is supposed to work and we do not
want to "optimize" for broken devices (or broken cheap crap, as someone
concisely described before).

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
>  like: "discard failed, please consider disabling discard support")

I think that we do not need to revert it, we just need to do the "right
thing" in the underlying layers. That said:

1. We need to honor all the "discard limits" so the discard bios does
not actually fail.
2. If the device is composed of various other devices, we should return
-EOPNOTSUPP is none of the devices support discard.
3. We should succeed, if at least one of the devices support discard and
it does not fail for any reason.
4. We should not advertise discard_zeroes_data if any of the devices
does not zero data or does not support discard.

I am not sure how "hard" is to assure those conditions in DM. If those
conditions are met, we can rely on consistent information in the layers
above.

Thanks!
-Lukas

> 
> 1) The user asked for discards (with '-o discard' mount option)
>    - what is the real harm in coninuing to issue them even if it _seems_
>      they aren't supported?
> 2) assuming the entire block device uniformly supports discards can
>    be flawed (a DM device's discard support can vary based on logical
>    offset).
> 
> Thoughts?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
