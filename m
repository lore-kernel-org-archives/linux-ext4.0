From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [stable] Stable patches for ext4
Date: Sat, 18 Oct 2008 22:03:59 -0500
Message-ID: <48FAA39F.8070202@redhat.com>
References: <E1KrCdX-0006L5-2q@closure.thunk.org> <20081018170305.GB20305@kroah.com> <20081018192856.GB8383@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Greg KH <greg@kroah.com>, linux-ext4@vger.kernel.org,
	stable@kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYJSDE0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Oct 2008 23:04:26 -0400
In-Reply-To: <20081018192856.GB8383@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sat, Oct 18, 2008 at 10:03:05AM -0700, Greg KH wrote:
>> Heh, you do realize that hundreds of thousands of users are going to be
>> using 2.6.27.x "for production" as at least 3 distros are being based
>> off of it?
>>
>> So, either you send these patches to us if you want to have a sane idea
>> of what the distros are using, or you rely on the distros themselves to
>> get it right in cherry-picking from upstream here.  I know one distro
>> already has done this, and I'm sure others have as well.
>>
>> It comes down to who you trust, a random distro engineer, or you and
>> your group of engineers :)
> 
> Heh**2.  What Fedora 10 at least is going to be doing is grabbing the
> equivalent of ext4-stable.  If it were completely up to me, and Eric
> Sandeen from Red Hat has made the same wish (although I suspectly
> somewhat in jest) on #ext4, it would be great if we could pour all of
> ext4-stable (i.e., what we got added into the malinline during the
> 2.6.28 merge window) into 2.6.27.x.

Well, in reality Fedora 10 will be getting these patches, whether they
come in via 2.6.27.x or not.  (Many/most are already in, most of the
rest will follow).  We've been advocating for ext4 in Fedora, so it
makes sense for us to keep it up to date with the latest patches in any
case.  (I've been slightly gunshy over the writeback changes just
because there was a bit of flux up until the end, but they may still
make it; also I'm holding off on fiemap until it officially sees the
light of day.)  But I guess I'm one of those rare "random distro
engineers" who is also one of "Ted's group of engineers."  ;)

So don't fret over Fedora w.r.t. 2.6.27.x; I think we've got it covered.
 Fedora 10 will also get 2.6.28 at some point.  So I'm not personally
worried.  I wonder how anxious other distros are to ship bona-fide ext4
in 2.6.27?

Anyway; I hope to find some time to look over the -stable nominated
patches, at first glance it looks like a pretty sane patchset.  I
wouldn't really advocate dumping all of 2.6.28's ext4 code into
2.6.27-stable, that'd be some pretty serious rule-bending I think.

-Eric
